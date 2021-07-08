## Configure Vault

Create secret:  
secret/test message='Hello from Vault'

Create policy file:  
path "secret/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}