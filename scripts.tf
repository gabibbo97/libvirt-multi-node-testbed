# Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("templates/ansible_inventory.tftpl", {
    nodes = var.nodes
    node_ips_map = local.node_ips_map
    ssh_key_filename = abspath(local_sensitive_file.ssh_key.filename)
  })
  filename = "${path.module}/outputs/ansible_inventory.yml"
}

# SSH script
resource "local_file" "ssh_script" {
  content = templatefile("templates/ssh_script.tftpl", {
    nodes = var.nodes
    node_ips_map = local.node_ips_map
    ssh_key_filename = abspath(local_sensitive_file.ssh_key.filename)
  })
  filename = "${path.module}/outputs/ssh_script.sh"
  file_permission = "0700"
}

# SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_key" {
  content = tls_private_key.ssh_key.private_key_openssh
  filename = "${path.module}/outputs/ssh_key"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/outputs/ssh_key.pub"
  file_permission = "0644"
}