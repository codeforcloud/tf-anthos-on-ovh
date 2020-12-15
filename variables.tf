variable "username" {
  type        = string
  description = "Your OVH username"
}

variable "password" {
  type        = string
  description = "Your OVH password"
}

variable "tenant-name" {
  type        = string
  description = "Your OVH tenant name"
}

variable "region" {
  type        = string
  description = "The default region where the instances will be created"
  default     = "GRA7"
}

variable "cluster-name" {
  type        = string
  description = "The name of the cluster"
  default     = "anthos"
}

variable "admin-instance-size" {
  type        = string
  description = "Instance size for the admin workstation"
  default     = "b2-7"
}

variable "ha-control-plane" {
  type        = bool
  description = "If the control plane should be deployed as a HA configuration (i.e. 3 nodes for the control plane)"
  default     = false
}

variable "control-plane-instance-size" {
  type        = string
  description = "Instance size for the control plane. For now, Anthos minimal configuration is b2-30"
  default     = "b2-30"
}

variable "worker-node-count" {
  type        = number
  description = "The number of workers of your cluster"
  default     = 1
}

variable "worker-node-instance-size" {
  type        = string
  description = "Instance size for the node pool. For now, Anthos minimal configuration is b2-30"
  default     = "b2-30"
}

variable "instance-image-name" {
  type        = string
  description = "OS base image for the instances (currently only work with Ubuntu 18.04/20.04, RHEL 8.1/8.2 or CentOS 8.1/8.2)"
  default     = "Ubuntu 18.04"
}

variable "gcp-service-account-key-name" {
  description = "Name of your GCP Service account key"
}

variable "gcp-project" {
  description = "GCP project where Anthos will be enabled"
}

variable "private-subnet" {
  type        = string
  description = "Private CIDR for subnet"
  default     = "172.29.254.0/24"
}

variable "anthos-baremetal-version" {
  type        = string
  description = "Version of Anthos baremetal"
  default     = "1.6.0"
}
