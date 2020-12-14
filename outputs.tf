output "admin-ip" {
  description = "Admin workstation IP"
  value       = openstack_compute_instance_v2.admin.access_ip_v4
}

output "control-plane-ips" {
  description = "Control plane IP(s)"
  value       = openstack_compute_instance_v2.control-plane.*.access_ip_v4
}

output "worker-node-ips" {
  description = "Node pool IP(s)"
  value       = openstack_compute_instance_v2.worker-node.*.access_ip_v4
}

output "anthos-cli" {
  value = "You can now create your cluster with the following command: GOOGLE_APPLICATION_CREDENTIALS=~/${var.gcp-service-account-key-name} ./bmctl create cluster --cluster ${var.cluster-name}"
}