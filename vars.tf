# Network settings
variable "dns_forward_addresses" {
  type = list(string)
  default = [
    # Cloudflare public DNS
    "1.1.1.1",
    "1.0.0.1",
  ]
}

variable "node_cidr" {
  type = string
  default = "172.16.42.0/24"
}

variable "libvirt_network_domain" {
  type = string
  default = "test.local"
}

variable "libvirt_network_mtu" {
  type = string
  default = 9000
}

variable "libvirt_network_name" {
  type = string
  default = "test_net"
}

# Node
variable "nodes" {
  type = list(string)
  default = [
    "node1",
    "node2",
    "node3",
  ]
}

variable "cpu_count" {
  type = number
  default = 2
}

variable "memory_mb" {
  type = number
  default = 4096
}

variable "root_disk_size_gib" {
  type = number
  default = 100
}

variable "extra_disks_count" {
  type = number
  default = 0
}

variable "extra_disks_size_gib" {
  type = number
  default = 50
}

# Image
variable "image_url" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/20220810/jammy-server-cloudimg-amd64.img"
}

# Storage
variable "libvirt_pool_name" {
  type = string
  default = "test_pool"
}

variable "libvirt_pool_dir" {
  type = string
  default = "/var/lib/libvirt/test"
}