# Policy: AzureOpenAIPublicAccessValidation
# Resource type: azurerm_cognitive_account
# Checked attribute path: public_network_access_enabled
# Expected: PASS because public network access is disabled.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_openai_public_access" {
  name     = "rg-pass-openai-public"
  location = "eastus"
}

resource "azurerm_cognitive_account" "pass_openai_public_access" {
  name                          = "pass-openai-public-acct"
  location                      = azurerm_resource_group.rg_pass_openai_public_access.location
  resource_group_name           = azurerm_resource_group.rg_pass_openai_public_access.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}
