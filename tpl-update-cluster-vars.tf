data "template_file" "update-cluster-vars" {
  template = file("update-cluster-vars.py")

  vars = {
    private-subnet      = var.private-subnet
    control-plane-count = var.ha-control-plane ? 3 : 1
    worker-node-count   = var.worker-node-count
    cluster-name        = var.cluster-name
  }
}
