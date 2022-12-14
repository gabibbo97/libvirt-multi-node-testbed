resource "libvirt_cloudinit_disk" "test_cloudinit" {
    for_each = toset(var.nodes)
    name = "${each.value}_cloudinit.raw"
    user_data = templatefile("templates/cloud-init.cfg", {
        hostname = each.value
        domain = var.libvirt_network_domain
        ssh_key = chomp(tls_private_key.ssh_key.public_key_openssh)
    })
    network_config = templatefile("templates/cloud-init-net.cfg", {
        address = "${local.node_ips_map[each.value]}/${local.node_cidr_bits}"
        gateway = cidrhost(var.node_cidr, 1)
        mtu = var.libvirt_network_mtu
    })
    pool = libvirt_pool.test_pool.name
}

locals {
  node_cidr_bits = split("/", var.node_cidr)[1]
}

resource "libvirt_volume" "test_rootdisk" {
    for_each = toset(var.nodes)
    name = "${each.value}_rootdisk.qcow2"
    pool = libvirt_pool.test_pool.name
    base_volume_id = libvirt_volume.test_image.id
    size = var.root_disk_size_gib * 1000 * 1000 * 1000
}

resource "libvirt_volume" "test_sparedisk" {
    for_each = toset(flatten([
        for i, node_name in var.nodes: [
            for j in range(var.extra_disks_count):
            "${node_name}_${j}"
        ]
    ]))
    name = "${each.value}_sparedisk.qcow2"
    pool = libvirt_pool.test_pool.name
    size = var.extra_disks_size_gib * 1000 * 1000 * 1000
}

resource "libvirt_domain" "test_domain" {
    for_each = toset(var.nodes)
    name = each.value

    vcpu = var.cpu_count
    memory = var.memory_mb

    cpu {
        mode = "host-model"
    }
    
    # Console
    console {
        type = "pty"
        target_port = "0"
    }

    # Disks
    cloudinit = libvirt_cloudinit_disk.test_cloudinit[each.value].id

    disk {
        volume_id = libvirt_volume.test_rootdisk[each.value].id
    }
    dynamic "disk" {
        for_each = range(var.extra_disks_count)
        content {
            volume_id = libvirt_volume.test_sparedisk["${each.value}_${disk.value}"].id
        }
    }

    # Network
    network_interface {
        network_id = libvirt_network.test_net.id
        addresses = [
            local.node_ips_map[each.value]
        ]
        hostname = each.value
        wait_for_lease = false
    }

}