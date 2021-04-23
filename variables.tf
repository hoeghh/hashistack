### Nomad server configuration ###
variable "nomad_server_count" {
  description = "The number of Nomad servers to create"
  default = 2
}


### Nomad client configuration ###
variable "nomad_client_count" {
  description = "The number of Nomad clients to create"
  default = 2
}

### Common configuration ###
variable "os_image" {
  description = "Define the source to the os image used by nomad"
  default = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
}