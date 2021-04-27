
terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      version = "0.6.3"
      source = "registry.terraform.io/dmacvicar/libvirt"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "nomad" {
  name = "nomad"
  type = "dir"
  path = var.nomad_pool_path
}
