locals {
    node_cidr_bits = split("/", var.node_cidr)[1]
    node_ips_map = { for i, node_name in var.nodes: node_name => cidrhost(var.node_cidr, 10+i*10) }
    node_mac_map = { for i, node_name in var.nodes: node_name => format("AA:BB:CC:DD:EE:%02X", 10+i*10) }
    cd_path = var.attach_cd_path != null ? "${var.libvirt_pool_dir}/${basename(var.attach_cd_path)}" : null
    images_map = {
        # Debian
        "debian-12"   = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
        # Fedora
        "fedora-38"   = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2"
        # Ubuntu
        "ubuntu-2204" = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    }
    image_url = try(coalesce(var.image_url, lookup(local.images_map, tostring(var.image_name), null)), null)
}
