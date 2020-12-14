resource "openstack_compute_secgroup_v2" "worker-node-sg" {
  name        = format("%s-worker-node-sg", var.cluster-name)
  description = "worker-node-sg"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
    #    description = "SSH"
  }

  rule {
    from_port   = 53
    to_port     = 53
    ip_protocol = "udp"
    cidr        = "0.0.0.0/0"
    #    description = "DNS"
  }

  rule {
    from_port   = 4240
    to_port     = 4240
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "CNI health check"
  }

  rule {
    from_port   = 6081
    to_port     = 6081
    ip_protocol = "udp"
    cidr        = var.private-subnet
    #    description = "GENEVE Encapsulation"
  }

  rule {
    from_port   = 10250
    to_port     = 10250
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "kubelet API"
  }

  rule {
    from_port   = 30000
    to_port     = 32767
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "NodePort Services"
  }
}
