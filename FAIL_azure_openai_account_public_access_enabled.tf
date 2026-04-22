# Policy: AzureOpenAIPublicAccessValidation
# Resource type: azurerm_cognitive_account
# Checked attribute path: public_network_access_enabled
# Expected: FAIL because public network access is enabled.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_openai_public_access" {
  name     = "rg-fail-openai-public"
  location = "eastus"
}

resource "azurerm_cognitive_account" "fail_openai_public_access" {
  name                          = "fail-openai-public-acct"
  location                      = azurerm_resource_group.rg_fail_openai_public_access.location
  resource_group_name           = azurerm_resource_group.rg_fail_openai_public_access.name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = true
}
