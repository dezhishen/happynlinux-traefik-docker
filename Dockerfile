FROM alpine as happynet-builder
RUN apk add --no-cache curl
WORKDIR /builder
ARG HAPPYNET_VERSION=1.0
RUN curl -sSL https://ghproxy.com/https://github.com/happynclient/happynlinux/raw/$HAPPYNET_VERSION/bin/docker/happynet -o happynet

FROM alpine as traefik-builer
RUN apk add --no-cache curl
WORKDIR /builder
ARG TRAEFIK_VERSION=v2.8.7
RUN curl -sSL https://ghproxy.com/https://github.com/traefik/traefik/raw/$TRAEFIK_VERSION/script/ca-certificates.crt -o ca-certificates.crt
RUN curl -sSL https://ghproxy.com/https://github.com/traefik/traefik/releases/download/$TRAEFIK_VERSION/traefik_$TRAEFIK_VERSION_linux_amd64.tar.gz -o traefik_v2.8.7_linux_amd64.tar.gz
RUN tar -xzf traefik_v2.8.7_linux_amd64.tar.gz

FROM alpine
EXPOSE 80
COPY --from=happynet-builder /builder/happynet /usr/local/bin/happynet
COPY --from=traefik-builer /builder/traefik /usr/local/bin/traefik
COPY --from=traefik-builer /builder/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/traefik"]
