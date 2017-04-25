FROM alpine:3.5

ARG BITCOIN_UNLIMITED_VERSION=1.0.1.4

WORKDIR /srv/src

RUN apk add --no-cache \
  git build-base \
  automake \
  autoconf \
  libtool \
  boost-dev \
  openssl-dev \
  libevent-dev \

  && git clone https://github.com/BitcoinUnlimited/BitcoinUnlimited.git \
  && cd BitcoinUnlimited \
  && git checkout tags/${BITCOIN_UNLIMITED_VERSION} \

  && ./autogen.sh \
  && ./configure --disable-wallet --without-gui --without-miniupnpc \
  && make \
  && make install \

  && cd /srv/src \
  && rm -rf BitcoinUnlimited

VOLUME ["/root/.bitcoin"]

EXPOSE 8333

ENTRYPOINT ["bitcoind"]
