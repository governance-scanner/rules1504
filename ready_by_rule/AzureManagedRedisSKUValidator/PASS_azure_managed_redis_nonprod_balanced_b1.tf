# Policy: AzureManagedRedisSKUValidator
# Resource type: azurerm_managed_redis
# Checked attribute path: sku_name
# Expected: PASS because non-production uses allowlisted Balanced_B1.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_redis_cluster_b2" {
  name     = "rg-pass-redis-cluster-b2"
  location = "eastus"
}

resource "azurerm_managed_redis" "pass_redis_cluster_b2" {
  name                = "redispassclusterb2"
  resource_group_name = azurerm_resource_group.rg_pass_redis_cluster_b2.name
  location            = azurerm_resource_group.rg_pass_redis_cluster_b2.location
  sku_name            = "Balanced_B1" # FIX: current resource type and allowlisted non-production SKU
  tags = {
    environment = "dev"
  }

  default_database {} # FIX: required by the current azurerm_managed_redis schema for new instances
}
