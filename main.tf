
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

resource "libvirt_network" "test_network" {
   name = "test_network"
   addresses = ["10.18.3.0/24"]
   dhcp {
      enabled = false
   }
   dns {
     enabled = true
   }
}


