#!/bin/bash

[ -z "$CF_TOKEN" ] && echo "ERROR: CF_TOKEN not set" && exit 1

echo "[*] starting health check server on :8388..."
python3 -m http.server 8388 &

echo "[*] starting cloudflared in background..."
cloudflared tunnel --no-autoupdate \
  --protocol http2 \
  run --token "${CF_TOKEN}" &

echo "[*] all services started, waiting..."
wait
