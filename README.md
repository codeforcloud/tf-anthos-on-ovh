# Quick deployment of a standalone Anthos cluster on OVH
### based on the work done for Packet : https://github.com/c0dyhi11/terraform-metal-anthos-on-baremetal

TODO :
- [ ] Ability to choose base OS (Ubuntu or CentOS)
- [ ] Parametrize private key
- [ ] Remove public IPs from control plane and node worker
- [ ] Create a NAT gateway
- [ ] Create a base image with the pre-requisites already installed, with Packer
- [X] Configure security groups of control plane and node worker
- [X] Create an admin workstation to boostrap the cluster
- [X] Create the control plane
- [X] Create the worker nodes pool
- [X] Create a private network
