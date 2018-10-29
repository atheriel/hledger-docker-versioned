# Yet Another Dockerized Hledger

This repository contains a Dockerized distribution of the plain-text accounting
application [Hledger](http://hledger.org/) and its associated web application,
which is otherwise difficult to install without the prerequisite Haskell
environment.

In contrast to existing images, this project has two goals: small image sizes
and version pinning for the Hledger applications. The first of these goals is
still a work in progress.

## Building

You can use the provided Makefile to build the image, e.g. `make` or,
equivalently, `make image`.

Note that this project uses a two-stage image to separate builder and
application environments.

## Using the Image

By default, containers will run `hledger-web` on port 5000. In order to use it
with a local ledger journal file, you will need to (1) mount that file at
`/journal.txt`; and (2) map port 5000 in the container to a host port.

For example, if you have the journal file `2018.ledger` in the current
directory, you can view it in `hledger-web` at
[http://localhost:5000](http://localhost:5000) with the following invocation:

``` shell
$ docker run --name hledger --rm --detach \
             -v "`pwd`/2018.ledger":/journal.txt \
             -p 5000:5000 \
             hledger:1.11.1
```

When this container is running you can also run reports against this journal
file with `docker exec`, e.g.

``` shell
$ docker exec hledger hledger balance assets
```

To run regular `hledger` reports without a running webserver, you can pass the
command directly to `docker run`, e.g.

``` shell
$ docker run --rm \
             -v "`pwd`/2018.ledger":/journal.txt \
             hledger:1.11.1 \
             hledger balance assets
```

If you don't want to mount the ledger journal file, you can make use of `hledger
-f -` to read from standard input:

``` shell
$ cat 2018.ledger | docker run --rm -i hledger:1.11.1 hledger -f - balance assets
```

## Notes

The two-stage build process used here is inspired by Deni Bertovic's [blog post
on the subject](https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker).

For correctly building Hledger itself I am indebted to the [`hledger-install.sh`](https://github.com/simonmichael/hledger/blob/master/hledger-install/hledger-install.sh)
script.
