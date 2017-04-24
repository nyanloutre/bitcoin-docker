FROM alpine:3.5

ARG BERKELEYDB_VERSION=4.8.30
ARG BITCOIN_UNLIMITED_VERSION=1.0.1.3

WORKDIR /srv/src

RUN apk update \
  && apk add --no-cache \
  git build-base \
  automake \
  autoconf \
  libtool \
  boost-dev \
  openssl-dev \
  libevent-dev \

  && wget http://download.oracle.com/berkeley-db/db-${BERKELEYDB_VERSION}.tar.gz \
  && tar -xzf db-${BERKELEYDB_VERSION}.tar.gz \
  && rm db-${BERKELEYDB_VERSION}.tar.gz \
  && cd db-${BERKELEYDB_VERSION}/build_unix \
  && ../dist/configure --enable-cxx --prefix /usr/local \
  && make install \

  && cd /srv/src \
  && rm -rf db-${BERKELEYDB_VERSION} \

  && git clone https://github.com/BitcoinUnlimited/BitcoinUnlimited.git \
  && cd BitcoinUnlimited \
  && git checkout tags/${BITCOIN_UNLIMITED_VERSION} \

  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \

  && cd /srv/src \
  && rm -rf BitcoinUnlimited

VOLUME ["/root/.bitcoin"]

EXPOSE 8333

ENTRYPOINT ["bitcoind"]
