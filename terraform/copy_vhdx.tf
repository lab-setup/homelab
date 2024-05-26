# Copy a vhd from existing VM
resource "hyperv_vhd" "master_node_vhd" {
  path      = "${var.vm_path}\\master_node.${var.vm_hd_type}"
  source_vm = var.vhdx_path
}

resource "hyperv_vhd" "worker_node_1_vhd" {
  path      = "${var.vm_path}\\worker_node_1.${var.vm_hd_type}"
  source_vm = var.vhdx_path
}