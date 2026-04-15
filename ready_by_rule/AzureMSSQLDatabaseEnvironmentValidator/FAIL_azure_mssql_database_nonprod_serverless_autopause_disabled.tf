# Policy: AzureMSSQLDatabaseEnvironmentValidator
# Resource type: azurerm_mssql_database
# Checked attribute paths: tags.environment, elastic_pool_id, sku_name, auto_pause_delay_in_minutes
# Expected: FAIL because a non-production serverless database disables auto-pause with -1.
# FIX: Added dedicated coverage for the serverless auto-pause-disabled branch after satisfying the elastic_pool_id precondition.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_mssql_env_serverless" {
  name     = "rg-fail-mssql-env-sls"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_fail_mssql_env_serverless" {
  name                         = "sqlfailenvsls001"
  resource_group_name          = azurerm_resource_group.rg_fail_mssql_env_serverless.name
  location                     = azurerm_resource_group.rg_fail_mssql_env_serverless.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "fail_mssql_env_serverless" {
  name                         = "sqldbfailenvsls"
  server_id                    = azurerm_mssql_server.sql_fail_mssql_env_serverless.id
  sku_name                     = "GP_S_Gen5_2" # FIX: serverless SKU prefix used by the policy
  max_size_gb                  = 32
  min_capacity                 = 0.5
  elastic_pool_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Sql/servers/example-sql/elasticPools/example-pool" # FIX: satisfies the earlier elastic_pool_id check
  auto_pause_delay_in_minutes  = -1 # FIX: reaches the intended FAIL branch
  tags = {
    environment = "dev"
  }
}
