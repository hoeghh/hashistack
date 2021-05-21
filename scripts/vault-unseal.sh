#!/bin/bash

#export VAULT_KEYS='{"keys":["860e9f247e992b9f7838251ff0952d8cec5f8ead6fb13543ae13e49b26628ad78e","d06d1b55b98a6178bcc6ca297a42938cfffcc7355419c322a7685c104a7f9f8f9d","5220a0ddf371eefa45344b4bdc0f61a1a29e6975b17f798126309d60cd1cde8ad2","13e12c38c1117d4a967d9abeea9e518783f0619201c09a4816ea3bca59dde84713","c2ae3633efc0e463793a6b76b815c0a1c3d588b63128778ac30c222659fec62030","78291d3915784efe13e523c3c1da27e7ad96f7f2644093dc80f9c0c3a9f0354601","e05336eb1a4d4725dd17d6e41344c2c001d4e2821031c8c321fc239419af80187d","8ba894a66adeeb398fe1bc42e89b16fdd0124b0da698304b025b87b8b8d3333cd8","8fe7d2fe94159e7d32859679a351b53be2e2bc36b97e83a7a868814b07be4cd5cc","da3a6428efcb53d3fafbb0bf07df4c244bc88c7f537a59d06555c07c2c7c9ed453"],"keys_base64":["hg6fJH6ZK594OCUf8JUtjOxfjq1vsTVDrhPkmyZiiteO","0G0bVbmKYXi8xsopekKTjP/8xzVUGcMip2hcEEp/n4+d","UiCg3fNx7vpFNEtL3A9hoaKeaXWxf3mBJjCdYM0c3orS","E+EsOMERfUqWfZq+6p5Rh4PwYZIBwJpIFuo7ylnd6EcT","wq42M+/A5GN5Omt2uBXAocPViLYxKHeKwwwiJln+xiAw","eCkdORV4Tv4T5SPDwdon562W9/JkQJPcgPnAw6nwNUYB","4FM26xpNRyXdF9bkE0TCwAHU4oIQMcjDIfwjlBmvgBh9","i6iUpmre6zmP4bxC6JsW/dASSw2mmDBLAluHuLjTMzzY","j+fS/pQVnn0yhZZ5o1G1O+LivDa5foOnqGiBSwe+TNXM","2jpkKO/LU9P6+7C/B99MJEvIjH9TelnQZVXAfCx8ntRT"],"root_token":"s.60qWf9SzLR4Y3rIJtvmB5TZO"}'

#export VAULT_IP="10.4.5.6:8200"
#echo "Vault IP: $VAULT_IP"
#echo $VAULT_KEYS

VAULT_PORT="8200"
UNSEAL_KEYS=$(echo $VAULT_KEYS | jq -r '.keys[]' )

if [ ! -z "$VAULT_KEYS" ] && [ ! -z "$VAULT_IP" ];then
  while IFS= read -r line; do
    $("vault operator unseal --tls-skip-verify https://${VAULT_IP} $line")
  done <<< "$UNSEAL_KEYS"
else
  echo "Variable VAULT_KEYS OR VAULT_IP is empty!"
fi
