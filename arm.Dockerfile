ARG MINIO_VERSION

#
# 1. Prepare latest version of scripts from x86_64 version
#
FROM minio/minio as minio

#
# 2. Build Min.io application for ARM
#
FROM golang:1.13 as builder

ARG MINIO_VERSION

RUN set -x \
    && cd /opt \
    && git clone https://github.com/minio/minio -b $MINIO_VERSION \
    && cd /opt/minio \
    && GOOS=linux GOARCH=arm64 go build -tags kqueue -o /usr/bin/minio \
    && test -f /usr/bin/minio

#
# 3. Create an output image on the ARM base
#
FROM balenalib/armv7hf-debian:buster

COPY --from=minio /usr/bin/docker-entrypoint.sh /usr/bin/
COPY --from=builder /usr/bin/minio /usr/bin/

ARG MINIO_VERSION
ENV MINIO_ACCESS_KEY_FILE= \
    MINIO_SECRET_KEY_FILE= \
    MINIO_UPDATE=off

RUN [ "cross-build-start" ]
RUN \
     apt-get update && \
     apt-get install -y ca-certificates curl && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     chmod +x /usr/bin/minio  && \
     chmod +x /usr/bin/docker-entrypoint.sh
RUN [ "cross-build-end" ]

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

CMD ["minio"]
