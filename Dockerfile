# 预烘焙 caddy（瘦身版）：内置 caddy-dns/cloudflare
# 构建：CADDY_VERSION=<上游标签，如 2.11.7>（由 workflow 自动解析）
ARG CADDY_VERSION=latest

FROM caddy:${CADDY_VERSION}-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM alpine:latest
ARG CADDY_VERSION
LABEL org.opencontainers.image.source="https://github.com/era-cloud/caddy"
LABEL org.opencontainers.image.version="${CADDY_VERSION}"
RUN apk add --no-cache ca-certificates tzdata
ENV XDG_CONFIG_HOME=/config XDG_DATA_HOME=/data
RUN mkdir -p /config /data
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
