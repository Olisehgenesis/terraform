terraform {
  required_providers {
    
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.93.0"
    }

    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
  tenant_id       = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
   features {}
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/NAFTechnologyServices"
  personal_access_token = "xx"

}

data "azurerm_resource_group" "CORP-LE-NafNet-RG" {
  name = "CORP-LE-NafNet-RG"
}

#output "name" {
#  value = data.azurerm_resource_group.CORP-LE-NafNet-RG.name
#}

data "azuredevops_project" "cloud%architecture%templates" {
  name = "cloud%architecture%templates"
}

# Load a specific Git repository by name
data "azuredevops_git_repository" "modules" {
  project_id = "data.azuredevops_project.project.id"
  name       = "modules"
}


#provider "azurerm" {
 #subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
 # tenant_id = 72d81d7f-a1f9-4082-9866-5e47ef460908
 # client_id = 72d81d7f-a1f9-4082-9866-5e47ef460908
 # client_secret = var.client_secret


terraform {
  backend "azurerm" {
    resource_group_name  = "TS-Terraform-RG"
    storage_account_name = "tsterraformsa"
    container_name       = "dev"
    key                  = "naftest.terraform.tfstate"
    subscription_id = "7b91df65-1f96-40d9-bcef-a3f85479ad2b"
    tenant_id       = "04986fa2-6d28-46f7-966a-b1ac32f74fa8"
    client_id = "72d81d7f-a1f9-4082-9866-5e47ef460908"
    client_secret = "xxkR"
  }
}
