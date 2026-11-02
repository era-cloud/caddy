# 预烘焙 caddy：内置 caddy-dns/cloudflare，消除容器启动期 caddy add-package 的 52MB 下载
# （该下载实测 8s~422s，是 gateway 重建时唯一的长尾）
FROM caddy:builder AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM caddy:latest
LABEL org.opencontainers.image.source="https://github.com/era-cloud/caddy"
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
