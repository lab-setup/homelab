# Configure HyperV
provider "hyperv" {
  user            = var.user
  password        = var.password
  host            = var.host
  port            = 5986
  https           = true
  insecure        = true
  use_ntlm        = true
  tls_server_name = ""
  cacert_path     = ""
  cert_path       = ""
  key_path        = ""
  script_path     = "C:/Temp/terraform_%RAND%.cmd"
  timeout         = "30s"
}

# Create a vhd
resource "hyperv_vhd" "vm_vhd" {
  path = "${var.vm_path}\\${var.vm_name}.${var.vm_hd_type}"
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

data "archive_file" "iso_image" {
  type        = "zip"
  source_dir  = "${var.iso_source}"
  output_path = "${var.iso_name}.zip"
}

resource "hyperv_iso_image" "iso_image" {
  volume_name               = "${var.iso_name}"
  source_zip_file_path      = data.archive_file.iso_image.output_path
  source_zip_file_path_hash = data.archive_file.iso_image.output_sha
  destination_iso_file_path = "$env:TEMP\\${var.iso_name}.iso"
  iso_media_type            = "dvdplusrw_duallayer"
  iso_file_system_type      = "unknown"
}

resource "hyperv_vhd" "server_vhd" {
  path = "${var.vm_path}\\${var.vm_name}.vhdx" #Needs to be absolute path
  size = 10737418240                          #10GB
}

resource "hyperv_machine_instance" "default" {
  name                                    = "temp_vm"
  generation                              = 2
  automatic_critical_error_action         = "Pause"
  automatic_critical_error_action_timeout = 30
  automatic_start_action                  = "Start"
  automatic_start_delay                   = 0
  automatic_stop_action                   = "ShutDown"
  checkpoint_type                         = "Disabled"
  guest_controlled_cache_types            = false
  high_memory_mapped_io_space             = 536870912
  lock_on_disconnect                      = "Off"
  low_memory_mapped_io_space              = 134217728
  # memory_maximum_bytes                    = 1099511627776
  # memory_minimum_bytes                  = 4294967296
  memory_startup_bytes                    = 4294967296
  notes                                   = ""
  processor_count                         = 1
  # smart_paging_file_path                  = "C:\\ProgramData\\Microsoft\\Windows\\Hyper-V"
  # snapshot_file_location                  = "C:\\ProgramData\\Microsoft\\Windows\\Hyper-V"
  # dynamic_memory                         = false
  static_memory = true
  state         = "Running"

  # Configure firmware
  vm_firmware {
    enable_secure_boot = "Off"
    #secure_boot_template            = ""
    preferred_network_boot_protocol = "IPv4"
    console_mode                    = "None"
    pause_after_boot_failure        = "Off"
    boot_order {
      boot_type           = "HardDiskDrive"
      controller_number   = "0"
      controller_location = "0"
    }
    boot_order {
      boot_type            = "NetworkAdapter"
      network_adapter_name = "wan"
    }
  }

  # Configure processor
  vm_processor {
    compatibility_for_migration_enabled               = false
    compatibility_for_older_operating_systems_enabled = false
    hw_thread_count_per_core                          = 0
    maximum                                           = 100
    reserve                                           = 0
    relative_weight                                   = 100
    maximum_count_per_numa_node                       = 0
    maximum_count_per_numa_socket                     = 0
    enable_host_resource_protection                   = false
    expose_virtualization_extensions                  = false
  }

  # Configure integration services
  integration_services = {
    "Guest Service Interface" = false
    "Heartbeat"               = true
    "Key-Value Pair Exchange" = true
    "Shutdown"                = true
    "Time Synchronization"    = true
    "VSS"                     = true
  }

  # Create dvd drive
  dvd_drives {
    controller_number   = "0"
    controller_location = "1"
    //path = ""
    path               = hyperv_iso_image.iso_image.destination_iso_file_path
    resource_pool_name = ""
  }

  # Create a hard disk drive
  hard_disk_drives {
    controller_type                 = "Scsi"
    controller_number               = "0"
    controller_location             = "0"
    path                            = hyperv_vhd.server_vhd.path
    disk_number                     = 4294967295
    resource_pool_name              = "Primordial"
    support_persistent_reservations = false
    maximum_iops                    = 0
    minimum_iops                    = 0
    qos_policy_id                   = "00000000-0000-0000-0000-000000000000"
    override_cache_attributes       = "Default"
  }
}