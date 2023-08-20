resource "libvirt_cloudinit_disk" "test_cloudinit" {
    for_each = toset(var.nodes)
    name = "${each.value}_cloudinit.raw"
    user_data = templatefile("templates/cloud-init.cfg", {
        hostname = each.value
        domain = var.libvirt_network_domain
        ssh_key = chomp(tls_private_key.ssh_key.public_key_openssh)
        username = var.username
    })
    network_config = templatefile("templates/cloud-init-net.cfg", {
        address = "${local.node_ips_map[each.value]}/${local.node_cidr_bits}"
        gateway = cidrhost(var.node_cidr, 1)
        mac = local.node_mac_map[each.value]
        mtu = var.libvirt_network_mtu
    })
    pool = libvirt_pool.test_pool.name
}
