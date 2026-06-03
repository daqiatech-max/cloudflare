#!/bin/bash

[ -z "$CF_TOKEN" ] && echo "ERROR: CF_TOKEN not set" && exit 1

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
" &

echo "[*] starting cloudflared..."
cloudflared tunnel --no-autoupdate \
  --protocol http2 \
  run --token "${CF_TOKEN}" &

echo "[*] all services started"
wait
