# Policy: AzureWindowsVMSkuRestrictionValidator
# Resource type: azurerm_windows_virtual_machine
# Checked attribute path: size
# Expected: FAIL because the non-production Windows VM uses a size outside the allowlist.
# FIX: Added explicit FAIL coverage for the Windows VM size allowlist policy.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_windows_vm_sku" {
  name     = "rg-fail-win-vm-sku"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_windows_vm_sku" {
  name                = "vnet-fail-win-vm-sku"
  location            = azurerm_resource_group.rg_fail_windows_vm_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_windows_vm_sku.name
  address_space       = ["10.83.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_windows_vm_sku" {
  name                 = "snet-fail-win-vm-sku"
  resource_group_name  = azurerm_resource_group.rg_fail_windows_vm_sku.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_windows_vm_sku.name
  address_prefixes     = ["10.83.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_windows_vm_sku" {
  name                = "nic-fail-win-vm-sku"
  location            = azurerm_resource_group.rg_fail_windows_vm_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_windows_vm_sku.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_windows_vm_sku.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "fail_windows_vm_sku" {
  name                  = "winvmfailsku"
  resource_group_name   = azurerm_resource_group.rg_fail_windows_vm_sku.name
  location              = azurerm_resource_group.rg_fail_windows_vm_sku.location
  size                  = "Standard_D16s_v3" # FIX: intentionally not in governance allowlist
  admin_username        = "azureuser"
  admin_password        = "P@ssword1234!"
  network_interface_ids = [azurerm_network_interface.nic_fail_windows_vm_sku.id]
  tags = {
    environment = "dev"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
