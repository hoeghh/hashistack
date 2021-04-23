
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
  path = "/tmp/terraform-provider-libvirt-pool-nomad"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}


