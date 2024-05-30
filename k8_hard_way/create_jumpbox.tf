resource "hyperv_machine_instance" "jumpbox" {
  name                                    = "jumpbox"
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
  memory_startup_bytes                    = 4294967296
  notes                                   = ""
  processor_count                         = 1
  static_memory                           = true
  state                                   = "Running"

  # Configure firmware
  vm_firmware {
    enable_secure_boot              = "Off"
    preferred_network_boot_protocol = "IPv4"
    console_mode                    = "None"
    pause_after_boot_failure        = "Off"
    # boot_order {
    #   boot_type           = "DvdDrive"
    #   path = var.iso_path
    #   controller_number   = "0"
    #   controller_location = "1"
    # }
    boot_order {
      boot_type           = "HardDiskDrive"
      controller_number   = "0"
      controller_location = "0"
    }
  }

  # Configure processor
  vm_processor {
    compatibility_for_migration_enabled               = false
    compatibility_for_older_operating_systems_enabled = false
    hw_thread_count_per_core                          = 1  # Threads allocation for VM
    maximum                                           = 40 # Max Percentage of CPU cores to be allocated
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
  # dvd_drives {
  #   controller_number   = "0"
  #   controller_location = "1"
  #   //path = ""
  #   path               = var.iso_path
  #   resource_pool_name = ""
  # }

  # Create a hard disk drive
  hard_disk_drives {
    controller_type                 = "Scsi"
    controller_number               = "0"
    controller_location             = "0"
    path                            = hyperv_vhd.vm_vhd.path
    disk_number                     = 4294967295
    resource_pool_name              = "Primordial"
    support_persistent_reservations = false
    maximum_iops                    = 0
    minimum_iops                    = 0
    qos_policy_id                   = "00000000-0000-0000-0000-000000000000"
    override_cache_attributes       = "Default"
  }
}