# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        redis \
    && mkdir -p /defaults/ \
    && mv /etc/redis.conf /defaults/redis.conf.default \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
VOLUME /var/lib/redis/
#
EXPOSE 6379 6380
#
HEALTHCHECK \
    --interval=2m \
    --retries=5 \
    --start-period=5m \
    --timeout=10s \
    CMD redis-cli ping || exit 1
#
ENTRYPOINT ["/init"]
