FROM alpine:latest
MAINTAINER Ryan Schlesinger <ryan@outstand.com>

RUN apk add --no-cache bash gawk sed grep bc coreutils tar \
    && mkdir /backup
COPY run.sh /usr/local/bin/run.sh
COPY backup.sh /usr/local/bin/backup
COPY restore.sh /usr/local/bin/restore
