# Copy a vhd from existing VM
resource "hyperv_vhd" "jumpbox_vhd" {
  path      = "${var.vm_path}\\jumpbox\\jumpbox.${var.vm_hd_type}"
  source = var.vhdx_path
}

resource "hyperv_vhd" "server_vhd" {
  path      = "${var.vm_path}\\server\\server.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.jumpbox_vhd ]
}

resource "hyperv_vhd" "node_0_vhd" {
  path      = "${var.vm_path}\\node_0\\node_0.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.server_vhd ]
}

resource "hyperv_vhd" "node_1_vhd" {
  path      = "${var.vm_path}\\node_1\\node_1.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.node_0_vhd ]
}