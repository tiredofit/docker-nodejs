FROM tiredofit/debian:buster
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Environment Variables
   ENV ENABLE_CRON=FALSE \
       ENABLE_SMTP=FALSE

### Add Users
   RUN adduser --home /app --gecos "Node User" --disabled-password nodejs && \

### Install NodeJS
       curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
       echo 'deb https://deb.nodesource.com/node_14.x buster main' > /etc/apt/sources.list.d/nodesource.list && \
       echo 'deb-src https://deb.nodesource.com/node_14.x buster main' >> /etc/apt/sources.list.d/nodesource.list && \
       apt-get update && \
       apt-get upgrade
       apt-get install -y \
               nodejs \
               yarn \
               && \
       \
       apt-get clean && \
       apt-get autoremove -y && \
       rm -rf /var/lib/apt/lists/*
