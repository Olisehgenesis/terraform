locals {
  resource_type_abbreviation_local_key_vault = "KV"
  location_local_key_vault                   = "West US 3"
}

resource "azurerm_key_vault" "key_vault" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_key_vault}-KV"
  location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
  resource_group_name = data.azurerm_resource_group.CORP-LE-NafNet-RG.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Update",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "UnwrapKey",
  ]
}

data "azurerm_client_config" "current" {}
