# Policy: CloudServiceControlPolicy
# Resource type: all
# Checked attribute path: node_name substring matching
# Expected: PASS because the resource type/name does not contain a blocked service substring.
# FIX: Added PASS coverage for the cloud service control policy.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "allowed_service_control" {
  name     = "rg-pass-cloud-service-control"
  location = "eastus"
}
