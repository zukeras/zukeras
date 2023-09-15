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

variable "subnet_name" {
    type = list(string)
    description = "Names of subnets"
    default = [ "dev_subnt","test_subnet" ]
  
}
variable "subnet_addresses" {
    type = list(string)
    description = "Subnets addresses"
    default = [ "10.1.1.0/24","10.1.2.0/24" ]
  
}
variable "tags" {
    type = map(string)
    description = "Tags for resources"
    default = {
      "enviroment" = "DEV",
      "project" = "NewDEVHome",
      "team" = "Software Home"
    }
  
}
