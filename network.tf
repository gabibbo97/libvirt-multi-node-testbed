resource "libvirt_network" "test_net" {
    name = var.libvirt_network_name
    mode = "nat"
    addresses = [
        var.node_cidr
    ]
    domain = var.libvirt_network_domain
    dhcp {
        enabled = true
    }
    dns {
        enabled = true
        dynamic "forwarders" {
            for_each = var.dns_forward_addresses
            content {
                address = forwarders.value
            }
        }
    }
    mtu = var.libvirt_network_mtu
}

locals {
  node_ips_map = { for i, node_name in var.nodes: node_name => cidrhost(var.node_cidr, 10+i*10) }
}
