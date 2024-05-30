# Copy a vhd from existing VM
resource "hyperv_vhd" "vm_vhd" {
  path      = "${var.vm_path}\\${var.vm_name}.${var.vm_hd_type}"
  source_vm = var.vhdx_path
}