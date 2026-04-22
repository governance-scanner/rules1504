# Policy: AzureOpenAISkuValidation
# Resource type: azurerm_cognitive_deployment
# Checked attribute path: model.name
# Expected: FAIL because the deployment model is explicitly denied by governance.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_openai_model" {
  name     = "rg-fail-openai-model"
  location = "eastus"
}

resource "azurerm_cognitive_account" "account_fail_openai_model" {
  name                          = "fail-openai-model-acct"
  location                      = azurerm_resource_group.rg_fail_openai_model.location
  resource_group_name           = azurerm_resource_group.rg_fail_openai_model.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "fail_openai_model" {
  name                 = "fail-openai-model"
  cognitive_account_id = azurerm_cognitive_account.account_fail_openai_model.id

  model {
    format  = "OpenAI"
    name    = "o1"
    version = "1"
  }

  sku {
    name     = "Standard"
    capacity = 1
  }
}
