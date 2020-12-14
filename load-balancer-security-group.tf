resource "openstack_compute_secgroup_v2" "load-balancer-sg" {
  name        = format("%s-load-balancer-sg", var.cluster-name)
  description = "load-balancer-sg"

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
    from_port   = 6444
    to_port     = 6444
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "Kubernetes API server"
  }

  rule {
    from_port   = 7946
    to_port     = 7946
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "Metal LB health check"
  }

  rule {
    from_port   = 7946
    to_port     = 7946
    ip_protocol = "udp"
    cidr        = var.private-subnet
    #    description = "Metal LB health check"
  }
}
