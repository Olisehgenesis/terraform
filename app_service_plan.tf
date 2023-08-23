locals {
  resource_type_abbreviation_local = "ASP"
  location_local                   = "West US 3"
  pricing_tier_local               = "S1"
  operating_system_local            = "Windows"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local}-ASP"
  location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
  resource_group_name = data.azurerm_resource_group.CORP-LE-NafNet-RG.name

  sku {
    tier = local.pricing_tier_local
    size = "S1"
  }

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }

  reserved = local.operating_system_local == "Linux"
  is_xenon = local.operating_system_local == "Linux"
  hyper_v  = local.operating_system_local == "Linux"
}
