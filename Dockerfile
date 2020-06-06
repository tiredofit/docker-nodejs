FROM tiredofit/alpine:3.6
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV NODEJS_VERSION=4.9.1 \
    NPM_VERSION=2 \
    YARN_VERSION=1.22.4

RUN set -x && \
    adduser -h /app -g "Node User" -D nodejs && \
    apk add --no-cache \
            curl \
            libstdc++ \
            make \
            gcc \
            g++ \
            python \
            linux-headers \
            binutils-gold \
            gnupg && \
    \
    curl -sSLO https://github.com/nodejs/node/archive/v${NODEJS_VERSION}.tar.gz && \
    tar -xf v${NODEJS_VERSION}.tar.gz && \
    cd node-${NODEJS_VERSION} && \
    ./configure --prefix=/usr ${CONFIG_FLAGS} && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    cd / && \
    if [ -z "$CONFIG_FLAGS" ]; then \
        npm install -g npm@${NPM_VERSION} && \
        find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf && \
        if [ -n "$YARN_VERSION" ]; then \
            curl -sSL -O https://github.com/yarnpkg/yarn/releases/download/v${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz && \
            mkdir /usr/local/share/yarn && \
            tar -xf yarn-v${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 && \
            ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ && \
            ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ && \
            rm yarn-v${YARN_VERSION}.tar.gz* ; \
        fi ;\
    fi && \
    \
    ## Cleanup
    apk del \
            make \
            gcc \
            g++ \
            python \
            linux-headers \
            binutils-gold \
            gnupg ${DEL_PKGS} && \
    rm -rf ${RM_DIRS} /node-${NODEJS_VERSION}* /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp \
                    /root/.gnupg /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
                    /usr/lib/node_modules/npm/scripts