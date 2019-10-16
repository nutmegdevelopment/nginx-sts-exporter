FROM golang:1.13-alpine AS builder

RUN apk --update add ca-certificates git

ENV GOPATH=/src/local

WORKDIR /src/local/example.com/nginx-sts-exporter
COPY go.* /src/local/example.com/nginx-sts-exporter/
COPY *.go /src/local/example.com/nginx-sts-exporter/

RUN go get -d -v && \
    GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w -s' -o /tmp/nginx-sts-exporter

# Runtime image
FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /tmp/nginx-sts-exporter /bin/nginx-sts-exporter

ENV NGINX_HOST "http://localhost"
ENV METRICS_ENDPOINT "/metrics"
ENV METRICS_ADDR ":9913"
ENV DEFAULT_METRICS_NS "nginx"

ENTRYPOINT [ "/bin/nginx-sts-exporter" ]

