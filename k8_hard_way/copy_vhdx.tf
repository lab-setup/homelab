# Copy a vhd from existing VM
resource "hyperv_vhd" "jumphost_vhd" {
  path      = "${var.vm_path}\\jumpbox\\jumpbox.${var.vm_hd_type}"
  source = var.vhdx_path
}

resource "hyperv_vhd" "k8_server_vhd" {
  path      = "${var.vm_path}\\k8_server\\k8_server.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.jumphost_vhd ]
}

resource "hyperv_vhd" "k8_worker_0_vhd" {
  path      = "${var.vm_path}\\k8_worker_0\\k8_worker_0.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.k8_server_vhd ]
}

resource "hyperv_vhd" "k8_worker_1_vhd" {
  path      = "${var.vm_path}\\k8_worker_1\\k8_worker_1.${var.vm_hd_type}"
  source = var.vhdx_path
  depends_on = [ hyperv_vhd.k8_worker_0_vhd ]
}