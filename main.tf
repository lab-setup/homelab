# Configure HyperV
provider "hyperv" {
  user            = var.user
  password        = var.password
  host            = var.host
  port            = 5986
  https           = true
  insecure        = false
  use_ntlm        = true
  tls_server_name = ""
  cacert_path     = ""
  cert_path       = ""
  key_path        = ""
  script_path     = "C:/Temp/terraform_%RAND%.cmd"
  timeout         = "30s"
}

# Create a switch
# resource "hyperv_network_switch" "dmz" {
# }

# Create a vhd
resource "hyperv_vhd" "webserver" {
  path = "d:\\VMs\\vitual.vhdx"
  #source               = ""
  #source_vm            = ""
  #source_disk          = 0
  vhd_type = "Dynamic"
  #parent_path          = ""
  size = 10737418240 #10GB
  #block_size           = 0
  #logical_sector_size  = 0
  #physical_sector_size = 0
}

# Create a machine
resource "hyperv_machine_instance" "simple_vm" {
}