FROM fpco/stack-build:lts-12 as builder

ARG HLEDGER_VERSION=1.11.1

RUN stack update
RUN stack install --system-ghc --compiler ghc-8.4.3 \
  hledger-${HLEDGER_VERSION} \
  hledger-web-${HLEDGER_VERSION} \
  hledger-lib-${HLEDGER_VERSION} \
  # Extra dependency.
  cassava-megaparsec-1.0.0

FROM ubuntu:16.04
RUN apt-get update && apt-get install -y libgmp10

COPY --from=builder /root/.local/bin/hledger /usr/local/bin/hledger
COPY --from=builder /root/.local/bin/hledger-web /usr/local/bin/hledger-web
