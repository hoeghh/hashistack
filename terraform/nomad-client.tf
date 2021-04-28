# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "nomad-client" {
  count  = length(var.nomad_client_ips)
  name   = "nomad-client-${count.index}"
  pool   = libvirt_pool.nomad.name
  source = var.os_image
  format = "qcow2"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "client-init" {
  count          = length(var.nomad_client_ips)
  name           = "client-init-${count.index}.iso"
  user_data      = data.template_file.client_user_data[count.index].rendered
  pool           = libvirt_pool.nomad.name
}

data "template_file" "client_user_data" {
  count = length(var.nomad_client_ips)
  template = file("${path.cwd}/templates/cloud_init_client.cfg")
  vars = {
    HOSTNAME = upper(format(
      "%v-%v",
      var.nomad_client_name,
      count.index
    )),
    NOMAD_SERVER_JOIN_IP = element(var.nomad_server_ips, 0),
    DATACENTER_NAME = var.datacenter_name
  }
}

# Create the machine
resource "libvirt_domain" "domain-nomad-client" {
  count  = length(var.nomad_client_ips)
  name   = "nomad-client-${count.index}"
  memory = var.nomad_client_memory
  vcpu   = var.nomad_client_vcpu

  cloudinit = libvirt_cloudinit_disk.client-init[count.index].id

  network_interface {
    network_id = libvirt_network.nomad_network.id
    hostname  = "${var.nomad_client_name}-${count.index}"
    addresses = ["${element(var.nomad_client_ips, count.index)}"]
    wait_for_lease = true
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.nomad-client[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    connection {
      host     = "${self.network_interface.0.addresses.0}"
      type     = "ssh"
      user     = "hashicorp"
      password = "eficode"
    }
#    connection {
#      type     = "ssh"
#      user     = "hashicorp"
#      password = "${var.root_password}"
#      host     = "${var.host}"
#    }
    inline = [
      "cloud-init status --wait > /dev/null 2>&1",
    ]
  }
}
