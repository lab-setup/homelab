resource "hyperv_machine_instance" "server" {
  name                                    = "server"
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
  processor_count                         = 2
  static_memory                           = true
  state                                   = "Running"
  depends_on                              = [hyperv_vhd.server_vhd]

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
    expose_virtualization_extensions                  = true
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
    path                            = hyperv_vhd.server_vhd.path
    disk_number                     = 4294967295
    resource_pool_name              = "Primordial"
    support_persistent_reservations = false
    maximum_iops                    = 0
    minimum_iops                    = 0
    qos_policy_id                   = "00000000-0000-0000-0000-000000000000"
    override_cache_attributes       = "Default"
  }
  network_adaptors {
    name                                       = "wan"
    switch_name                                = "des"
    management_os                              = false
    is_legacy                                  = false
    dynamic_mac_address                        = false
    static_mac_address                         = "00-15-5D-00-05-04"
    mac_address_spoofing                       = "Off"
    dhcp_guard                                 = "Off"
    router_guard                               = "Off"
    port_mirroring                             = "None"
    ieee_priority_tag                          = "Off"
    vmq_weight                                 = 100
    iov_queue_pairs_requested                  = 1
    iov_interrupt_moderation                   = "Off"
    iov_weight                                 = 100
    ipsec_offload_maximum_security_association = 512
    maximum_bandwidth                          = 0
    minimum_bandwidth_absolute                 = 0
    minimum_bandwidth_weight                   = 0
    mandatory_feature_id                       = []
    resource_pool_name                         = ""
    test_replica_pool_name                     = ""
    test_replica_switch_name                   = ""
    virtual_subnet_id                          = 0
    allow_teaming                              = "On"
    not_monitored_in_cluster                   = false
    storm_limit                                = 0
    dynamic_ip_address_limit                   = 0
    device_naming                              = "Off"
    fix_speed_10g                              = "Off"
    packet_direct_num_procs                    = 0
    packet_direct_moderation_count             = 0
    packet_direct_moderation_interval          = 0
    vrss_enabled                               = true
    vmmq_enabled                               = false
    vmmq_queue_pairs                           = 16
  }
}