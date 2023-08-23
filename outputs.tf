output "id" {
  value = data.azurerm_resource_group.CORP-LE-NafNet-RG.id
}

output "name" {
  value = data.azurerm_resource_group.CORP-LE-NafNet-RG.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

output "app_insights_instrumentation_key" {
  value = azurerm_application_insights.app_insights.instrumentation_key
}

output "app_service_url" {
  value = azurerm_app_service.static_app.default_site_hostname
}

output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.storage_account.primary_connection_string
}

# Add more outputs as needed based on your infrastructure design.
