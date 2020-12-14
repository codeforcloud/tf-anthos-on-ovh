resource "openstack_compute_instance_v2" "control-plane" {
  count           = var.ha-control-plane ? 3 : 1
  name            = format("%s-control-plane-%02d", var.cluster-name, count.index + 1)
  image_name      = var.instance-image-name
  flavor_name     = var.control-plane-instance-size
  key_pair        = openstack_compute_keypair_v2.ssh-key.name
  security_groups = [openstack_compute_secgroup_v2.control-plane-sg.id,openstack_compute_secgroup_v2.load-balancer-sg.id]
  #  tags            = [var.cluster-name, "control-plane"]

  network {
    name = "Ext-Net"
  }

  network {
    uuid        = openstack_networking_network_v2.anthos-network.id
    fixed_ip_v4 = cidrhost(openstack_networking_subnet_v2.anthos-subnet.cidr, count.index + 100)
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.access_ip_v4
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      # "sudo apt update && sudo apt -y full-upgrade",

      # Clean-up
      "sudo apt -y autoremove --purge && sudo apt -y clean",

      # Deactivate AppArmor and UFW
      "sudo systemctl stop apparmor",
      "sudo systemctl disable apparmor",
      "sudo ufw disable"
    ]
  }
}
