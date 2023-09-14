variable "rg_name" {
    type = string
    description = "name of main resource group"
    default = "terraform-resources"
}

variable "location" {
    type = string
    description = "Location of resources"
    default = "UK South"
}

variable "vm_name" {
    type = string
    description = "Name of VM"
    default = "linuxVM"
}

variable "vnet_address_space" {
    type = string
    description = "Address space of VNET"
    default = "10.0.0.0/16"
}

variable "disable_password_authentification" {
    type = bool
    description = "is password authentification disabled?"
    default = true
  
}