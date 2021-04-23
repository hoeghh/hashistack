### Nomad server configuration ###
variable "nomad_server_count" {
  description = "The number of Nomad servers to create"
  default = 2
}
variable "nomad_server_vcpu" {
  description = "The number of vcpu to assign Nomad server"
  default = 1
}
variable "nomad_server_memory" {
  description = "The number of memory to assign Nomad server"
  default = "512"
}


### Nomad client configuration ###
variable "nomad_client_count" {
  description = "The number of Nomad clients to create"
  default = 2
}
variable "nomad_client_vcpu" {
  description = "The number of vcpu to assign Nomad clients"
  default = 2
}
variable "nomad_client_memory" {
  description = "The number of memory to assign Nomad client"
  default = "1024"
}


### Common configuration ###
variable "os_image" {
  description = "Define the source to the os image used by nomad"
  default = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
}