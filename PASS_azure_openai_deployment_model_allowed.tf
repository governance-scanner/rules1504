# Policy: AzureOpenAISkuValidation
# Resource type: azurerm_cognitive_deployment
# Checked attribute path: model.name
# Expected: PASS because the deployment model is not on the governance denylist.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_openai_model" {
  name     = "rg-pass-openai-model"
  location = "eastus"
}

resource "azurerm_cognitive_account" "account_pass_openai_model" {
  name                          = "pass-openai-model-acct"
  location                      = azurerm_resource_group.rg_pass_openai_model.location
  resource_group_name           = azurerm_resource_group.rg_pass_openai_model.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "pass_openai_model" {
  name                 = "pass-openai-model"
  cognitive_account_id = azurerm_cognitive_account.account_pass_openai_model.id

  model {
    format  = "OpenAI"
    name    = "text-curie-001"
    version = "1"
  }

  sku {
    name     = "Standard"
    capacity = 1
  }
}
