# Policy: AzureLinuxVMSkuRestrictionValidator
# Resource type: azurerm_linux_virtual_machine
# Checked attribute path: size
# Expected: FAIL because the non-production Linux VM uses a size outside the allowlist.
# FIX: Added explicit FAIL coverage for the Linux VM size allowlist policy.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_linux_vm_sku" {
  name     = "rg-fail-linux-vm-sku"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_linux_vm_sku" {
  name                = "vnet-fail-linux-vm-sku"
  location            = azurerm_resource_group.rg_fail_linux_vm_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_linux_vm_sku.name
  address_space       = ["10.81.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_linux_vm_sku" {
  name                 = "snet-fail-linux-vm-sku"
  resource_group_name  = azurerm_resource_group.rg_fail_linux_vm_sku.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_linux_vm_sku.name
  address_prefixes     = ["10.81.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_linux_vm_sku" {
  name                = "nic-fail-linux-vm-sku"
  location            = azurerm_resource_group.rg_fail_linux_vm_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_linux_vm_sku.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_linux_vm_sku.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "fail_linux_vm_sku" {
  name                            = "vmfaillinuxsku"
  resource_group_name             = azurerm_resource_group.rg_fail_linux_vm_sku.name
  location                        = azurerm_resource_group.rg_fail_linux_vm_sku.location
  size                            = "Standard_D16s_v3" # FIX: intentionally not in governance allowlist
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.nic_fail_linux_vm_sku.id]
  disable_password_authentication = true
  tags = {
    environment = "dev"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFailLinuxVmSkuScannerKey"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
