terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.68.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=2.51.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "azuredevops" {
  org_service_url       = var.org_service_url
  personal_access_token = var.personal_access_token
}
