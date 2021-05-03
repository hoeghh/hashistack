### Common configuration ###
variable "datacenter_name" {
  description = "Name of the datacenter"
  default = "dc1"
}
variable "os_image" {
  description = "Define the source to the os image used by nomad"
  default = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
}
variable "nomad_pool_path" {
  description = "Define the path to libvirt pool"
  default = "/tmp/terraform-provider-libvirt-pool-nomad"
}
variable "nomad_drivers" {
  description = "List of drivers that should be enabled on the Nomad clients"
  type    = list(string)
  default = ["docker", "raw_exec", "java"]
}


### Nomad server configuration ###
variable "nomad_server_name" {
  description = "The name of the Nomad server"
  default = "nomad-server"
}
variable "nomad_server_ips" {
  description = "List of Nomad server ip's"
  type    = list(string)
  default = ["10.18.3.10", "10.18.3.11", "10.18.3.12"]
}
variable "nomad_server_enable_client" {
  description = "Enable the client on Nomad server"
  type = bool
  default = false
}
variable "nomad_server_vcpu" {
  description = "The number of vcpu to assign Nomad server"
  default = 1
}
variable "nomad_server_memory" {
  description = "The number of memory to assign Nomad server"
  default = "512"
}
variable "nomad_server_disk_size" {
  description = "The size of the disk on Nomad server"
  default = "4294965097" #4gb
}


### Nomad client configuration ###
variable "nomad_client_name" {
  description = "The name of the Nomad client"
  default = "nomad-client"
}
variable "nomad_client_ips" {
  description = "List of Nomad client ip's"
  type    = list(string)
  default = ["10.18.3.20", "10.18.3.21"]
}
variable "nomad_client_vcpu" {
  description = "The number of vcpu to assign Nomad clients"
  default = 2
}
variable "nomad_client_memory" {
  description = "The number of memory to assign Nomad client"
  default = "1024"
}
variable "nomad_client_disk_size" {
  description = "The size of the disk on Nomad client"
  default = "6442447645" #6gb
}


### Consul configuration ###
variable "consul-agent-ca-key" {
  description = "The CA key used by Consul"
  default = "/certificates/consul/consul-agent-ca-key.pem"
}
variable "consul-agent-ca" {
  description = "The CA used by Consul"
  default = "/certificates/consul/consul-agent-ca.pem"
}
variable "dc1-client-consul-0" {
  description = "The TLS cert for DC1"
  default = "/certificates/consul/dc1-client-consul-0.pem"
}
variable "dc1-server-consul-0-key" {
  description = "The client TLS Key file"
  default = "/certificates/consul/dc1-server-consul-0-key.pem"
}
variable "dc1-client-consul-0-key" {
  description = "The server TLS key file"
  default = "/certificates/consul/dc1-client-consul-0-key.pem"
}
variable "dc1-server-consul-0" {
  description = "The server TLS cert"
  default = "/certificates/consul/dc1-server-consul-0.pem"
}
variable "gossip_encryption_key" {
  description = "The gossip encryption key"
  default = "/certificates/consul/gossip_encryption_key"
}