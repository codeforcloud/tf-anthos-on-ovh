resource "openstack_networking_network_v2" "anthos-network" {
  name           = format("%s-network", var.cluster-name)
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "anthos-subnet" {
  name       = format("%s-subnet", var.cluster-name)
  network_id = openstack_networking_network_v2.anthos-network.id
  cidr       = var.private-subnet
  ip_version = 4
}
