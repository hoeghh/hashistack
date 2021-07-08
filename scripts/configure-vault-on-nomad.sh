#!/bin/bash

cat << EOF >> /etc/nomad.d/server.hcl
vault {
  enabled = true
  tls_skip_verify = true
  address = "https://${NODE_IP}:8200"
  token = "${VAULT_TOKEN}"
}
EOF