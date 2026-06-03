#!/bin/bash

[ -z "$CF_TOKEN" ] && echo "ERROR: CF_TOKEN not set" && exit 1
[ -z "$UUID" ] && echo "ERROR: UUID not set" && exit 1

echo "[*] generating xray config..."
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": 1986,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "level": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/daqiatech2render"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

echo "[*] starting xray..."
xray run -config /etc/xray/config.json &

echo "[*] starting cloudflared..."
cloudflared tunnel --no-autoupdate \
  --protocol http2 \
  run --token "${CF_TOKEN}" &

echo "[*] starting health check on :8388..."
python3 -c "
import http.server, socketserver
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'OK')
    def log_message(self, *a): pass
socketserver.TCPServer(('0.0.0.0', 8388), H).serve_forever()
"
