# Hashistack
![](https://img.shields.io/badge/Implemented-Terraform-green) ![](https://img.shields.io/badge/Implemented-Nomad-green) ![](https://img.shields.io/badge/Implemented-Consul-green) ![](https://img.shields.io/badge/Implemented-Vault-red)

## From Terraform to Nomad with Consul
This repository aims at automating a Hashicorp Nomad cluster including a Consul cluster with Terraform. 

It's highly customizable. It will use the libvirt terraform provider to create virtual machines that then installs the software. You can choose the number of server and clients and what Nomad drivers to install (["docker", "local_exec", "raw_exec", "java"] and it will do that for you.

Soon, we will have a quick guide but until then, be patient. 
