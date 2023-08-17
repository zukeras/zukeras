terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure-terraform_01" {
  name     = "terraform-resources"
  location = "West Europe"
}
resource "azurerm_virtual_network" "main_virtual_network" {
  name                = "main_network"
  location            = azurerm_resource_group.azure-terraform_01.location
  resource_group_name = azurerm_resource_group.azure-terraform_01.name
  address_space       = ["10.1.0.0/16"]

  subnet {
    name           = "dev_subnet"
    address_prefix = "10.1.1.0/24"
  }
  subnet {
    name           = "test_subnet"
    address_prefix = "10.1.2.0/24"
  }
}

