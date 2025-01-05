# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }

  required_version = ">= 0.14.9"
}


provider "azurerm" {
  features {}
}

# main below is local reference

resource "azurerm_resource_group" "main" {
  name = "learn-tf-rg-eastus"  
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name = "learn-tf-vnet-eastus"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = ["10.0.0.0/16"]
}

# we can declare subnet as its own block or within vnet

resource "azurerm_subnet" "main" {
  name = "learn-tf-subnet-eastus"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "internal" {
  name = "learn-tf-nic-internal-eastus"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    # can be static with subnet space
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name = "learn-tf-vm-eastus"
  computer_name = "learn-tf-vm"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size = "Standard_B1s"
  admin_username = "user.admin"
  # to keep with security best practices better to have password as variable
  admin_password = "enter@@Passowrd12345"

  network_interface_ids = [ azurerm_network_interface.internal.id ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-DataCenter"
    version = "latest"
  }
}