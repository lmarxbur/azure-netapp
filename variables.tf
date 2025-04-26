variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
  
}

variable "create_resource" {

  description = "Enable or disable monitoring for the VM"
  type        = bool
  default     = true
}
