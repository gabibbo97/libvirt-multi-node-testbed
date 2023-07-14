# Pool
resource "libvirt_pool" "test_pool" {
  name = var.libvirt_pool_name
  type = "dir"
  path = var.libvirt_pool_dir
}

# Image
resource "libvirt_volume" "test_image" {
  name   = "test_image"
  pool = libvirt_pool.test_pool.name
  source = local.image_url
}