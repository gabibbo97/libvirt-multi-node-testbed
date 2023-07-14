resource "libvirt_network" "test_net" {
    name = var.libvirt_network_name
    mode = "nat"
    addresses = [
        var.node_cidr
    ]
    # Enable DHCP
    dhcp {
        enabled = true
    }
    # Enable DNS
    domain = var.libvirt_network_domain
    dns {
        enabled = true
        # Forward to upstream
        dynamic "forwarders" {
            for_each = var.dns_forward_addresses
            content {
                address = forwarders.value
            }
        }
    }
    # Set MTU
    mtu = var.libvirt_network_mtu
}
