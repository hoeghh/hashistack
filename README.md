# Hashistack
![](https://img.shields.io/badge/Implemented-Terraform-green) ![](https://img.shields.io/badge/Implemented-Nomad-green) ![](https://img.shields.io/badge/Implemented-Consul-green) ![](https://img.shields.io/badge/Implemented-Vault-green)

## From Terraform to Nomad with Consul and Vault
This repository aims at automating a Hashicorp Nomad cluster including a Consul and Vault cluster using Terraform. 

It's highly customizable. It will use the libvirt terraform provider to create virtual machines that then installs the software. You can choose the number of server and clients and what Nomad drivers to install ("docker", "local_exec", "raw_exec", "java"] and it will do that for you.

Soon, we will have a quick guide but until then, be patient. 

## An overview of the platform
![hashistack-overview](https://user-images.githubusercontent.com/11328908/119959987-c96f7a00-bfa4-11eb-845d-cfbcd83a8daa.png)
