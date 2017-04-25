FROM alpine:3.5

ARG BITCOIN_UNLIMITED_VERSION=v1.0.1.4

WORKDIR /srv/src

RUN apk add --no-cache \
  git build-base \
  automake \
  autoconf \
  libtool \
  boost-dev \
  openssl-dev \
  libevent-dev \

  && git clone --branch tags/${BITCOIN_UNLIMITED_VERSION} --depth 1 https://github.com/BitcoinUnlimited/BitcoinUnlimited.git \
  && cd BitcoinUnlimited \

  && ./autogen.sh \
  && ./configure --disable-wallet --without-gui --without-miniupnpc \
  && make \
  && make install \

  && cd /srv/src \
  && rm -rf BitcoinUnlimited

VOLUME ["/root/.bitcoin"]

EXPOSE 8333

ENTRYPOINT ["bitcoind"]
