#!/bin/bash

VAULT_SCHEME="https"
VAULT_PORT="8200"

if [ ! -z "$VAULT_KEYS" ] && [ ! -z "$VAULT_IP" ];then
  UNSEAL_KEYS=$(cat $VAULT_KEYS | jq -r '.keys[]' )
  while IFS= read -r line; do
    eval curl --verbose --request PUT --insecure --data "'{\"key\": \"$line\"}'" ${VAULT_SCHEME}://${VAULT_IP}:$VAULT_PORT/v1/sys/unseal
    #vault operator unseal --tls-skip-verify -address=${VAULT_SCHEME}://${VAULT_IP}:$VAULT_PORT $line
  done <<< "$UNSEAL_KEYS"
else
  echo "Variable VAULT_KEYS OR VAULT_IP is empty!"
fi
