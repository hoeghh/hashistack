#!/bin/bash

VAULT_SCHEME="https"
VAULT_PORT="8200"
UNSEAL_KEYS=$(cat $VAULT_KEYS | jq -r '.keys[]' )

if [ ! -z "$VAULT_KEYS" ] && [ ! -z "$VAULT_IP" ];then
  while IFS= read -r line; do
    eval curl --verbose --request PUT --insecure --data "'{\"key\": \"$line\"}'" ${VAULT_SCHEME}://${VAULT_IP}:$VAULT_PORT/v1/sys/unseal
    #vault operator unseal --tls-skip-verify -address=${VAULT_SCHEME}://${VAULT_IP}:$VAULT_PORT $line
  done <<< "$UNSEAL_KEYS"
else
  echo "Variable VAULT_KEYS OR VAULT_IP is empty!"
fi
