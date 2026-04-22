# Policy: AzureOpenAIDeploymentCountValidation
# Resource type: azurerm_cognitive_deployment
# Checked attribute path: sku.capacity
# Expected: FAIL because deployment capacity exceeds the governance threshold of 10.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_openai_capacity" {
  name     = "rg-fail-openai-capacity"
  location = "eastus"
}

resource "azurerm_cognitive_account" "account_fail_openai_capacity" {
  name                          = "fail-openai-capacity-acct"
  location                      = azurerm_resource_group.rg_fail_openai_capacity.location
  resource_group_name           = azurerm_resource_group.rg_fail_openai_capacity.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "fail_openai_capacity" {
  name                 = "fail-openai-capacity"
  cognitive_account_id = azurerm_cognitive_account.account_fail_openai_capacity.id

  model {
    format  = "OpenAI"
    name    = "text-curie-001"
    version = "1"
  }

  sku {
    name     = "Standard"
    capacity = 11
  }
}
