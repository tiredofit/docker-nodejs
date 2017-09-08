FROM tiredofit/alpine:edge
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Environment Variables
ARG NODE_VERSION=6.11.0
ENV GPG_KEYS \
  9554F04D7259F04124DE6B476D5A82AC7E37093B \
  94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
  0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
  FD3A5288F042B6850C66B31F09FE44734EB7990E \
  71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  B9AE9905FFD7803F25714661B63B535A4C206CA9 \
  C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8


RUN build_pkgs="git curl make gcc g++ python linux-headers libgcc libstdc++ binutils-gold xz gnupg" && \
    apk --no-cache add ${build_pkgs} && \
    for key in $GPG_KEYS; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key"; \
    done && \
    cd /tmp && \
    curl -SLO https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.xz && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && \
    grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - && \
    tar -xJf "node-v$NODE_VERSION.tar.xz" && \
    cd /tmp/node-v${NODE_VERSION} && \
    ./configure --prefix=/usr --without-snapshot --fully-static && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    apk del ${build_pkgs} && \
    rm -rf /etc/ssl /node-v${NODE_VERSION} /usr/include /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html
