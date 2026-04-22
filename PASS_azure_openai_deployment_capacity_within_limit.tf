# Policy: AzureOpenAIDeploymentCountValidation
# Resource type: azurerm_cognitive_deployment
# Checked attribute path: sku.capacity
# Expected: PASS because deployment capacity is within the governance threshold of 10.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_openai_capacity" {
  name     = "rg-pass-openai-capacity"
  location = "eastus"
}

resource "azurerm_cognitive_account" "account_pass_openai_capacity" {
  name                          = "pass-openai-capacity-acct"
  location                      = azurerm_resource_group.rg_pass_openai_capacity.location
  resource_group_name           = azurerm_resource_group.rg_pass_openai_capacity.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "pass_openai_capacity" {
  name                 = "pass-openai-capacity"
  cognitive_account_id = azurerm_cognitive_account.account_pass_openai_capacity.id

  model {
    format  = "OpenAI"
    name    = "text-curie-001"
    version = "1"
  }

  sku {
    name     = "Standard"
    capacity = 10
  }
}
