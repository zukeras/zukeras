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
  location = "UK South"
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

resource "azurerm_public_ip" "linuxVM_ip" {
  name                = "linuxVM_ip"
  location            = azurerm_resource_group.azure-terraform_01.location
  resource_group_name = azurerm_resource_group.azure-terraform_01.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "linuxVM_nic" {
  name                = "linuxVM_nic"
  location            = azurerm_resource_group.azure-terraform_01.location
  resource_group_name = azurerm_resource_group.azure-terraform_01.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_virtual_network.main_virtual_network.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linuxVM_ip.id
  }

}

resource "azurerm_network_security_group" "nsg_shh" {
  name                = "linuxVM_nsg"
  location            = azurerm_resource_group.azure-terraform_01.location
  resource_group_name = azurerm_resource_group.azure-terraform_01.name

  security_rule {
    name                       = "test123"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id = azurerm_network_interface.linuxVM_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_shh.id
  
}
resource "azurerm_windows_virtual_machine" "linuxVM" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B2S"

  network_interface_ids = [
    azurerm_network_interface.linuxVM_nic.id,
  ]

  admin_username = "azureuser"
  admin_ssh_key {
    username = "azureuser"
    public_key = file("./.ssh/id_rsa.pub")
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
