locals {
    node_cidr_bits = split("/", var.node_cidr)[1]
    node_ips_map = { for i, node_name in var.nodes: node_name => cidrhost(var.node_cidr, 10+i*10) }
    images_map = {
        # Debian
        "debian-12"   = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
        # Ubuntu
        "ubuntu-2204" = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    }
    image_url = var.image_name == null ? var.image_url : local.images_map[var.image_name]
}
