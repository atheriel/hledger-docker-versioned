FROM fpco/stack-build:lts-12 as builder

ARG HLEDGER_VERSION=1.11.1

RUN stack update
RUN stack install --system-ghc --compiler ghc-8.4.3 \
  hledger-${HLEDGER_VERSION} \
  hledger-web-${HLEDGER_VERSION} \
  hledger-lib-${HLEDGER_VERSION} \
  # Extra dependency.
  cassava-megaparsec-1.0.0

FROM ubuntu:cosmic

RUN apt-get update && apt-get install -y libtinfo5

COPY --from=builder /root/.local/bin/hledger /usr/local/bin/hledger
COPY --from=builder /root/.local/bin/hledger-web /usr/local/bin/hledger-web

# Check that the image is working correctly.
RUN /usr/local/bin/hledger --version

# Keep the journal file where we can mount it.
ENV LEDGER_FILE=/journal.txt
RUN touch /journal.txt

# Set this to help resolve unicode issues.
ENV LANG=en_US.UTF-8

EXPOSE 5000

CMD ["/usr/local/bin/hledger-web", "--serve", "--host=0.0.0.0"]
STOPSIGNAL SIGINT
