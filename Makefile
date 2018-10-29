VERSION=1.11.1

all: image

image:
  # Break up the two-stage build to prevent pruning the builder image.
	docker build --build-arg HLEDGER_VERSION=${VERSION} \
               --target builder \
               -t hledger-builder:${VERSION} .
	docker build --build-arg HLEDGER_VERSION=${VERSION} \
               -t hledger:${VERSION} .

clean:
	docker rmi hledger-builder:${VERSION} hledger:${VERSION}

.PHONT: all image clean
