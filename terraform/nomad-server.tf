resource "libvirt_volume" "nomad-server" {
  count           = length(var.nomad_server_ips)
  name            = "nomad-server-${count.index}"
  base_volume_id  = libvirt_volume.os_image_ubuntu.id
  pool            = libvirt_pool.nomad.name
  size            = var.nomad_server_disk_size
  format          = "qcow2"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "server-init" {
  count          = length(var.nomad_server_ips)
  name           = "server-init-${count.index}.iso"
  user_data      = data.template_file.server_user_data[count.index].rendered
  pool           = libvirt_pool.nomad.name
}

data "template_file" "server_user_data" {
  count = length(var.nomad_server_ips)
  template = file("${path.cwd}/templates/cloud_init_server.cfg")
  vars = {
    HOSTNAME = upper(format(
      "%v-%v",
      var.nomad_server_name,
      count.index
    )),
    NOMAD_SERVER_COUNT = length(var.nomad_server_ips),
    NOMAD_SERVER_JOIN_IP = element(var.nomad_server_ips, 0),
    NOMAD_SERVER_ENABLE_CLIENT = var.nomad_server_enable_client,
    NOMAD_DRIVER_DOCKER = contains(var.nomad_drivers, "docker"),
    NOMAD_DRIVER_JAVA = contains(var.nomad_drivers, "java"),
    NOMAD_DRIVER_RAW_EXEC = contains(var.nomad_drivers, "raw_exec"),
    NODE_IP = "${element(var.nomad_server_ips, count.index)}",
    DATACENTER_NAME = var.datacenter_name
    CONSUL_AGENT_CA = indent(6, format ("\n%s", file("${path.cwd}${var.consul-agent-ca}"))),
    DC1_SERVER_CONSUL_0_KEY = indent(6, format ("\n%s", file("${path.cwd}${var.dc1-server-consul-0-key}"))),
    DC1_SERVER_CONSUL_0 = indent(6, format ("\n%s", file("${path.cwd}${var.dc1-server-consul-0}"))),
    GOSSIP_ENCRYPTION_KEY = file("${path.cwd}${var.gossip_encryption_key}")
  }
}

# Create the machine
resource "libvirt_domain" "domain-nomad-server" {
  count  = length(var.nomad_server_ips)
  name   = "${var.nomad_server_name}-${count.index}"
  memory = var.nomad_server_memory
  vcpu   = var.nomad_server_vcpu

  cloudinit = libvirt_cloudinit_disk.server-init[count.index].id

  network_interface {
    network_id = libvirt_network.nomad_network.id
    hostname  = "${var.nomad_server_name}-${count.index}"
    addresses = ["${element(var.nomad_server_ips, count.index)}"]
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
    volume_id = libvirt_volume.nomad-server[count.index].id
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

resource "null_resource" "vault-init" {
  depends_on = [
    libvirt_domain.domain-nomad-server
  ]

  provisioner "local-exec" {
    command = "curl --request PUT -k -d '{\"secret_shares\": 10, \"secret_threshold\": 5}' https://${element(var.nomad_server_ips, 0)}:8200/v1/sys/init > ${path.cwd}/vault.keys"
  }
}

resource "null_resource" "vault-unseal" {
  count  = length(var.nomad_server_ips)
  depends_on = [
    null_resource.vault-init
  ]

  provisioner "local-exec" {
    command = "${path.cwd}/scripts/vault-unseal.sh"

    environment = {
      VAULT_IP = "${element(var.nomad_server_ips, count.index)}"
      VAULT_KEYS = "${path.cwd}/vault.keys"
    }
  }
}