FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    python3 \
    curl \
    unzip \
 && curl -L --retry 3 --max-time 60 \
    https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    -o /usr/local/bin/cloudflared \
 && chmod +x /usr/local/bin/cloudflared \
 && curl -L --retry 3 --max-time 60 \
    https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    -o /tmp/xray.zip \
 && unzip /tmp/xray.zip -d /usr/local/bin/ \
 && chmod +x /usr/local/bin/xray \
 && rm -rf /tmp/xray.zip /var/lib/apt/lists/*

ENV CF_TOKEN=""
ENV UUID=""

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
