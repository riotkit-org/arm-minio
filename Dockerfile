FROM minio/minio as minio
FROM balenalib/armv7hf-debian:buster

COPY --from=minio /usr/bin/docker-entrypoint.sh /usr/bin/
COPY --from=minio /usr/bin/healthcheck /usr/bin/

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

RUN [ "cross-build-start" ]
RUN \
     apt-get update && \
     apt-get install -y ca-certificates curl && \
     echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
     cd /usr/bin && curl -ksSLO http://dl.minio.io/server/minio/release/linux-arm/minio && \
     chmod +x /usr/bin/minio  && \
     chmod +x /usr/bin/docker-entrypoint.sh && \
     chmod +x /usr/bin/healthcheck
RUN [ "cross-build-end" ]

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s \
    CMD /usr/bin/healthcheck

CMD ["minio"]
