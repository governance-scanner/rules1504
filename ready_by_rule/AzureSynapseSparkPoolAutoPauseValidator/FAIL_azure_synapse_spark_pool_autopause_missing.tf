# Policy: AzureSynapseSparkPoolAutoPauseValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_pause
# Expected: FAIL because the auto_pause block is omitted entirely.
# FIX: Added dedicated FAIL coverage for the missing auto_pause branch.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_synapse_autopause_missing" {
  name     = "rg-fail-syn-ap-miss"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_synapse_autopause_missing" {
  name                     = "safailsynapmissing"
  resource_group_name      = azurerm_resource_group.rg_fail_synapse_autopause_missing.name
  location                 = azurerm_resource_group.rg_fail_synapse_autopause_missing.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_synapse_autopause_missing" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_synapse_autopause_missing.id
}

resource "azurerm_synapse_workspace" "ws_fail_synapse_autopause_missing" {
  name                                 = "synwsfailautopausem"
  resource_group_name                  = azurerm_resource_group.rg_fail_synapse_autopause_missing.name
  location                             = azurerm_resource_group.rg_fail_synapse_autopause_missing.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_synapse_autopause_missing.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "fail_synapse_autopause_missing" {
  name                 = "sparkautopausemiss"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_synapse_autopause_missing.id
  node_size_family     = "None"
  node_size            = "Small"
  spark_version        = "3.3"
  cache_size           = 100
  tags = {
    environment = "dev"
  }

  auto_scale {
    min_node_count = 3
    max_node_count = 3
  }
  # FIX: auto_pause intentionally omitted so this file reaches exactly the missing-block branch
}
