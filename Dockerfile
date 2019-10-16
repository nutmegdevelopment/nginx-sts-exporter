FROM        quay.io/prometheus/busybox:latest
MAINTAINER  Bomb Squad <devops@nutmeg.com>

COPY nginx-sts-exporter  /bin/nginx-sts-exporter
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

ENV NGINX_HOST "http://localhost"
ENV METRICS_ENDPOINT "/metrics"
ENV METRICS_ADDR ":9913"
ENV DEFAULT_METRICS_NS "nginx"

ENTRYPOINT [ "docker-entrypoint.sh" ]
