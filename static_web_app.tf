locals {
  resource_type_abbreviation_local_static_web_app = "SWA"
  location_local_static_web_app                   = "West US 2"
}

variable "private_endpoint_enabled" {
  type    = bool
  default = false
}

variable "private_endpoint_subnet_id" {
  type = string
  # add default = subnet
}

resource "azurerm_static_site" "static_web_app" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_static_web_app}-SWA"
  location            = data.azurerm_resource_group.CORP-LE-NafNet-RG.location
  resource_group_name = data.azurerm_resource_group.CORP-LE-NafNet-RG.name

  sku {
    tier = "Standard"
  }

  app_settings = {
    "AzureStaticWebApps_SkipCustomDomainVerification" = "true"
  }

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }
}

resource "azurerm_static_site_custom_domain" "custom_domain" {
  static_site_name         = azurerm_static_site.static_web_app.name
  resource_group_name      = azurerm_resource_group.CORP-LE-NafNet-RG.name
  hostname                 = "example.com" # Replace with your custom domain
  use_subdomain_verification = false
}

resource "azurerm_static_site_custom_domain" "www_custom_domain" {
  static_site_name         = azurerm_static_site.static_web_app.name
  resource_group_name      = azurerm_resource_group.CORP-LE-NafNet-RG.name
  hostname                 = "www.example.com" # Replace with your custom domain
  use_subdomain_verification = false
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.CORP-LE-NafNet-RG.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_static_web_app}-VNETLink"
  resource_group_name = azurerm_resource_group.CORP-LE-NafNet-RG.name
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zone.id
  virtual_network_id  = var.private_endpoint_subnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link_www" {
  name                = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_static_web_app}-VNETLink-WWW"
  resource_group_name = azurerm_resource_group.CORP-LE-NafNet-RG.name
  private_dns_zone_id = azurerm_private_dns_zone.private_dns_zone.id
  virtual_network_id  = var.private_endpoint_subnet_id
}

resource "azurerm_static_site_virtual_network_binding" "static_web_app_vnet_binding" {
  static_site_name          = azurerm_static_site.static_web_app.name
  resource_group_name       = azurerm_resource_group.CORP-LE-NafNet-RG.name
  virtual_network_subnet_ids = [var.private_endpoint_subnet_id]
}

resource "azurerm_static_site_custom_https" "static_web_app_https" {
  static_site_name    = azurerm_static_site.static_web_app.name
  resource_group_name = azurerm_resource_group.CORP-LE-NafNet-RG.name
  use_sni             = true
}

# Conditionally deploy private endpoint based on variable setting
resource "azurerm_private_endpoint" "private_endpoint" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                 = "${var.department_abbreviation}-${var.major_environment}-${var.project}-${var.specific_environment}-${local.resource_type_abbreviation_local_static_web_app}-SWA-PE"
  location             = local.location_local_static_web_app
  resource_group_name  = azurerm_resource_group.CORP-LE-NafNet-RG.name
  subnet_id            = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "private-endpoint-connection"
    private_connection_resource_id = azurerm_static_site.static_web_app.id
    is_manual_connection           = true
    subresource_names              = ["web"]
  }

  tags = {
    Owner     = var.tag_owner
    Department = var.tag_department
  }
}
