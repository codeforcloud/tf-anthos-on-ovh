resource "openstack_compute_instance_v2" "admin" {
  name            = format("%s-admin", var.cluster-name)
  image_name      = var.instance-image-name
  flavor_name     = var.admin-instance-size
  key_pair        = openstack_compute_keypair_v2.ssh-key.name
  security_groups = ["default"]
  #  tags            = [var.cluster-name, "control-plane"]

  network {
    name = "Ext-Net"
  }

  network {
    uuid        = openstack_networking_network_v2.anthos-network.id
    fixed_ip_v4 = cidrhost(openstack_networking_subnet_v2.anthos-subnet.cidr, 10)
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.access_ip_v4
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = file("key/${var.gcp-service-account-key-name}")
    destination = "~/${var.gcp-service-account-key-name}"
  }

  provisioner "file" {
    content     = file("~/.ssh/id_rsa")
    destination = "~/.ssh/id_rsa"
  }

  provisioner "file" {
    content     = data.template_file.update-cluster-vars.rendered
    destination = "~/update-cluster-vars.py"
  }

  provisioner "remote-exec" {
    inline = [
      # "sudo apt update && sudo apt -y full-upgrade",
      "curl -fsSL https://get.docker.com | bash",
      "sudo usermod -aG docker $USER",

      # Install Google Cloud SDK
      "echo 'deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main' | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list",
      "curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -",
      "sudo apt update",
      "sudo apt -y install google-cloud-sdk",

      # Install Kubectl CLI
      "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      "sudo apt update",
      "sudo apt -y install kubectl",

      # Download bmctl
      "gcloud auth activate-service-account --key-file=${var.gcp-service-account-key-name}",
      "gsutil cp gs://anthos-baremetal-release/bmctl/${var.anthos-baremetal-version}/linux-amd64/bmctl .",
      "chmod u+x bmctl",

      # Clean-up
      "sudo apt -y autoremove --purge && sudo apt -y clean",

      # Deactivate AppArmor and UFW
      "sudo systemctl stop apparmor",
      "sudo systemctl disable apparmor",
      "sudo ufw disable",

      # Restrict permissions of private key
      "chmod 400 ~/.ssh/id_rsa",

      # Create Anthos cluster configuration
      "GOOGLE_APPLICATION_CREDENTIALS=~/${var.gcp-service-account-key-name} ./bmctl create config --cluster ${var.cluster-name} --enable-apis --create-service-accounts --project-id ${var.gcp-project}",

      # Update anthos configuration file
      "python3 update-cluster-vars.py"
    ]
  }
}
