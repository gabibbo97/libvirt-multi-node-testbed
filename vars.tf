# Network settings
variable "dns_forward_addresses" {
  description = "DNS to which requests are to be forwarded"
  type = list(string)
  default = [
    # Cloudflare public DNS
    "1.1.1.1",
    "1.0.0.1",
  ]
}

variable "node_cidr" {
  description = "CIDR from which IPs are to be allocated"
  type = string
  default = "172.16.42.0/24"
}

variable "libvirt_network_domain" {
  description = "Default DNS domain for domains"
  type = string
  default = "test.local"
}

variable "libvirt_network_mtu" {
  description = "MTU for the default network bridge"
  type = string
  default = 9000
}

variable "libvirt_network_name" {
  description = "Name of the libvirt network"
  type = string
  default = "test_net"
}

# Nodes
variable "nodes" {
  description = "Node names"
  type = list(string)
  default = [
    "node1",
    "node2",
    "node3",
  ]
}

variable "cpu_count" {
  description = "Number of vCPUs"
  type = number
  default = 2
}

variable "memory_mb" {
  description = "Amount of memory in MB"
  type = number
  default = 4096
}

variable "root_disk_size_gib" {
  description = "Size in GB of the root disk"
  type = number
  default = 100
}

variable "extra_disks_count" {
  description = "Number of additional disks to add"
  type = number
  default = 0
}

variable "extra_disks_size_gib" {
  description = "Size in GB of the additional disks"
  type = number
  default = 50
}

# Image
variable "image_url" {
  description = "Cloud-init image to use"
  type = string
  default = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

# Storage
variable "libvirt_pool_name" {
  description = "Storage pool to use"
  type = string
  default = "test_pool"
}

variable "libvirt_pool_dir" {
  description = "Storage pool path"
  type = string
  default = "/var/lib/libvirt/test"
}