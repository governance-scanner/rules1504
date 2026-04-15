# Policy: AzureNetAppVolumeQuotaValidator
# Resource type: azurerm_netapp_volume
# Checked attribute path: storage_quota_in_gb
# Expected result: FAIL because storage_quota_in_gb is below the 50 GiB minimum.
# FIX: Added explicit FAIL coverage for the NetApp volume quota validator.

resource "azurerm_resource_group" "rg_fail_volume_quota" {
  name     = "rg-netapp-fail-volume-quota"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_volume_quota" {
  name                = "vnet-fail-volume-quota"
  location            = azurerm_resource_group.rg_fail_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_fail_volume_quota.name
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_volume_quota" {
  name                 = "snet-fail-volume-quota"
  resource_group_name  = azurerm_resource_group.rg_fail_volume_quota.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_volume_quota.name
  address_prefixes     = ["10.21.1.0/24"]

  delegation {
    name = "netapp-delegation"

    service_delegation {
      name = "Microsoft.Netapp/volumes"
      actions = [
        "Microsoft.Network/networkinterfaces/*",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_netapp_account" "account_fail_volume_quota" {
  name                = "netappacctfailvolquota"
  location            = azurerm_resource_group.rg_fail_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_fail_volume_quota.name
}

resource "azurerm_netapp_pool" "pool_fail_volume_quota" {
  name                = "pool-fail-volume-quota"
  location            = azurerm_resource_group.rg_fail_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_fail_volume_quota.name
  account_name        = azurerm_netapp_account.account_fail_volume_quota.name
  service_level       = "Standard"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "volume_fail_volume_quota" {
  name                = "volume-fail-volume-quota"
  location            = azurerm_resource_group.rg_fail_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_fail_volume_quota.name
  account_name        = azurerm_netapp_account.account_fail_volume_quota.name
  pool_name           = azurerm_netapp_pool.pool_fail_volume_quota.name
  volume_path         = "volfailvolumequota"
  service_level       = "Standard"
  subnet_id           = azurerm_subnet.subnet_fail_volume_quota.id
  protocols           = ["NFSv4.1"]
  storage_quota_in_gb = 40 # FIX: below the 50 GiB minimum

  export_policy_rule {
    rule_index        = 1
    allowed_clients   = ["0.0.0.0/0"]
    protocols_enabled = ["NFSv4.1"]
    unix_read_only    = false
    unix_read_write   = true
  }
}
