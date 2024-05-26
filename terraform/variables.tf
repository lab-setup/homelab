variable "user" {
  type        = string
  description = "Username of the the host machine"
  default     = "vaibhav"
}

variable "password" {
  type        = string
  description = "host machine password"
  sensitive   = true
}

variable "host" {
  type        = string
  description = "host machine ip address"
  default     = "10.0.0.5"
}

# variable "vm_name" {
#   type        = string
#   description = "name of the vm to be created"
#   # default = "temp"
# }

variable "vm_path" {
  type        = string
  description = "path on host machine to store the vhdx"
  default     = "d:\\VMs"
}

variable "vm_hd_type" {
  type        = string
  description = "path on host machine to store the vhdx"
  default     = "vhdx"
}

variable "switch_name" {
  type        = string
  description = "path on host machine to store the vhdx"
  default     = "Default External Switch"
}

# variable "vhdx_path" {
#   type        = string
#   description = "VM name to copy vhdx from"
#   default     = "github-actions"
# }

variable "vhdx_path" {
  type        = string
  description = "Disk name to copy vhdx from"
  default     = "d:\\VMs\\github-actions\\Virtual Hard Disks\\github-actions.vhdx"
}