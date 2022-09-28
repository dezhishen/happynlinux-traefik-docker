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
RUN curl -sSL https://ghproxy.com/https://github.com/traefik/traefik/releases/download/$TRAEFIK_VERSION/traefik_${TRAEFIK_VERSION}_linux_amd64.tar.gz -o traefik_linux_amd64.tar.gz
RUN tar -xzvf traefik_linux_amd64.tar.gz

FROM ubuntu:focal
ENV TZ=Asia/Shanghai
RUN apt update && apt install tzdata -y && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
EXPOSE 80
COPY --from=happynet-builder /builder/happynet /usr/bin/
COPY --from=traefik-builer /builder/traefik /usr/bin/
COPY --from=traefik-builer /builder/ca-certificates.crt /etc/ssl/certs/
RUN chmod +x /usr/bin/happynet
RUN chmod +x /usr/bin/traefik
WORKDIR /data
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh","/usr/bin/entrypoint.sh"]
