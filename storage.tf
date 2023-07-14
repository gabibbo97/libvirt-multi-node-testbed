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

# Copy CDROM to pool
resource "null_resource" "copy_cdrom" {
  count = var.attach_cd_path != null ? 1 : 0
  triggers = {
    "src_path" = var.attach_cd_path
    "dst_path" = local.cd_path
  }
  provisioner "local-exec" {
    command = "sudo cp ${self.triggers.src_path} ${self.triggers.dst_path}"
  }
  provisioner "local-exec" {
    command = "sudo rm -f ${self.triggers.dst_path}"
    when = destroy
  }
  depends_on = [ libvirt_pool.test_pool ]
}
