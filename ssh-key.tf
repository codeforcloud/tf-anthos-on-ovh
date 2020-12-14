resource "openstack_compute_keypair_v2" "ssh-key" {
  name       = format("%s-public-key", var.cluster-name)
  public_key = file("~/.ssh/id_rsa.pub")
}
