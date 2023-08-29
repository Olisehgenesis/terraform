locals {
  resource_type_abbreviation_local_storage = "SA"
  location_local_storage                   = "West US 3"  
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.department_abbreviation}${var.major_environment}${var.project}${var.specific_environment}${local.resource_type_abbreviation_local_storage}"
  location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
  resource_group_name = data.azurerm_resource_group.CORP-LE-NafNet-RG.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }

  network_rules {
    default_action = "Deny"
  }
}
