FROM alpine:3.5

ARG BITCOIN_CLASSIC_VERSION=v1.2.5

WORKDIR /srv/src

RUN apk add --no-cache \
  git build-base \
  automake \
  autoconf \
  libtool \
  boost-dev \
  openssl-dev \
  libevent-dev \

  && git clone --branch ${BITCOIN_CLASSIC_VERSION} --depth 1 https://github.com/bitcoinclassic/bitcoinclassic.git \
  && cd bitcoinclassic \

  && ./autogen.sh \
  && ./configure --disable-wallet --without-gui --without-miniupnpc \
  && make \
  && make install \

  && cd /srv/src \
  && rm -rf bitcoinclassic

VOLUME ["/root/.bitcoin"]

EXPOSE 8333

ENTRYPOINT ["bitcoind"]
