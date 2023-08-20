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
    description = "libvirt-multi-node-testbed node ${each.value}"

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

    # Boot
    boot_device {
        dev = var.attach_cd_path != null ? [ "hd", "cdrom" ] : [ "hd" ]
    }

    # Disks
    ## Cloud-init
    cloudinit = libvirt_cloudinit_disk.test_cloudinit[each.value].id

    ## CDs
    dynamic "disk" {
        for_each = compact([ local.cd_path ])
        content {
            file = disk.value
        }
    }

    ## Root disk
    disk {
        volume_id = libvirt_volume.test_rootdisk[each.value].id
    }

    ## Spare disks
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
        mac = local.node_mac_map[each.value]
        hostname = "${each.value}.${var.libvirt_network_domain}"
        wait_for_lease = false
    }

    # Agent
    qemu_agent = true

    # UEFI
    firmware = var.uefi_firmware
    dynamic "nvram" {
        for_each = try([coalesce(var.uefi_firmware)], [])
        content {
          file = "${var.libvirt_pool_dir}/${each.value}.nvram"
        }
    }

    # Dependencies
    depends_on = [
        null_resource.copy_cdrom
    ]

}