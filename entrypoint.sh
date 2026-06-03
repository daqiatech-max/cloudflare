#!/bin/bash
set -e

[ -z "$CF_TOKEN" ] && echo "ERROR: CF_TOKEN not set" && exit 1

echo "[*] starting dummy http server on :1986..."
python3 -m http.server 1986 &

echo "[*] starting cloudflared..."
exec cloudflared tunnel --no-autoupdate \
  --protocol http2 \
  run --token "${CF_TOKEN}"
