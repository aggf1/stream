#!/bin/bash
ARGO_AUTH='eyJhIjoiMmY1YjMwYjRjNzEwNmZlMTg0ZTIwN2U4ZTA5ZTcxZmUiLCJ0IjoiNGY1MzY3MzUtNTAxNC00MTNlLTlmODQtOTA3ZDUwZGQ0Y2U5IiwicyI6Ik5EUTNPVE5qTmpjdFl6UmtNaTAwT1RVekxUazRNekF0WTJKak56ZGtPRGd4TUdRNCJ9'

generate_config() {
  cat > mouse.json << EOF
{
  "log":{
      "access":"/dev/null",
      "error":"/dev/null",
      "loglevel":"none"
    },
  "inbounds": [
    {
      "port": 8080,
      "listen":"0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "01010101-0101-0101-0101-010101010101"
          }
        ],
         "decryption":"none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
        "path": "/123"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
}

generate_web() {
  cat > psweb.sh << EOF
#!/usr/bin/env bash

check_file() {
  [ ! -e cat ] && wget -O cat https://arm64.ssss.nyc.mn/web
}

run() {
  chmod +x cat && ./cat -c ./mouse.json >/dev/null 2>&1 &
}

check_file
run
EOF
}

generate_argo() {
  cat > psargo.sh << ABC
#!/usr/bin/env bash

ARGO_AUTH=${ARGO_AUTH}

check_file() {
  [ ! -e dog ] && wget -O dog https://arm64.ssss.nyc.mn/2go
}

run() {
  chmod +x dog && ./dog tunnel --edge-ip-version auto --no-autoupdate --protocol http2 run --token ${ARGO_AUTH} 2>&1 &
}

check_file
run
ABC
}

generate_config
generate_web
generate_argo
[ -e psweb.sh ] && nohup bash psweb.sh >/dev/null 2>&1 &
[ -e psargo.sh ] && nohup bash psargo.sh >/dev/null 2>&1 &

sleep 120
rm -f mouse.json
rm -f psweb.sh
rm -f psargo.sh
