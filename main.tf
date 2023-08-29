data "azurerm_resource_group" "CORP-LE-NafNet-RG" {
  name = "CORP-LE-NafNet-RG"
}

data "azuredevops_project" "cloud%architecture%templates" {
  name = "cloud%architecture%templates"
}


data "azuredevops_git_repository" "modules" {
  project_id = data.azuredevops_project.project.id
  name       = "modules"
}

module "log_analytics" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=log_analytics"
}

module "application_insights" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=application_insights"
}

module "app_service_plan" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=app_service_plan"
}

module "app_service" {
  source           = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=app_service"
  operating_system = "Windows"  # Replace with the appropriate operating system value
}

module "static_web_app" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=static_web_app"
}

module "static_app" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=static_app"
}

module "key_vault" {
  source = "git::https://$(PAT_TOKEN)@.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=key_vault"
}

module "storage_account" {
  source = "git::https://$(PAT_TOKEN)@dev.azure.com/NAFTechnologyServices/Cloud%20Architecture%20Templates/modules/_git/modules?ref=naftest&path=storage_account"
}

