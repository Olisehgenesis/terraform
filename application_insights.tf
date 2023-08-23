locals {
  resource_type_abbreviation_local_app_insights = "AI"
  location_local_app_insights                   = "West US 3"
}

resource "azurerm_application_insights" "app_insights" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_app_insights}-APPIN"
  location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
  resource_group_name = data.azurerm_resource_group.CORP-LE-NafNet-RG.name

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }
}