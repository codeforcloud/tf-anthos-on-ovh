resource "openstack_compute_secgroup_v2" "control-plane-sg" {
  name        = format("%s-control-plane-sg", var.cluster-name)
  description = "control-plane-sg"

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
    from_port   = 2379
    to_port     = 2380
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "etcd server client API"
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
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "Kubernetes API server"
  }

  rule {
    from_port   = 6444
    to_port     = 6444
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "Control plane HA"
  }

  rule {
    from_port   = 10250
    to_port     = 10250
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "kubelet API"
  }

  rule {
    from_port   = 10251
    to_port     = 10251
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "kube-scheduler"
  }

  rule {
    from_port   = 10252
    to_port     = 10252
    ip_protocol = "tcp"
    cidr        = var.private-subnet
    #    description = "kube-controller-manager"
  }
}
