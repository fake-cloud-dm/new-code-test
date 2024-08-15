# Data block to retrieve the management group details
data "azurerm_management_group" "customer" {
  name = replace(lower(var.customer_name), " ", "-") # Replace with your management group's name
}

data "azurerm_management_group" "connectivity" {
  name = "${replace(lower(var.customer_name), " ", "-")}-connectivity" # Replace with your management group's name
}

data "azurerm_management_group" "identity" {
  name = "${replace(lower(var.customer_name), " ", "-")}-identity" # Replace with your management group's name
}

data "azurerm_management_group" "management" {
  name = "${replace(lower(var.customer_name), " ", "-")}-management" # Replace with your management group's name
}

data "azurerm_management_group" "platform" {
  name = "${replace(lower(var.customer_name), " ", "-")}-platform" # Replace with your management group's name
}

data "azurerm_management_group" "landing-zones" {
  name = "${replace(lower(var.customer_name), " ", "-")}-landing-zones" # Replace with your management group's name
}

data "azurerm_management_group" "corp" {
  name = "${replace(lower(var.customer_name), " ", "-")}-corp" # Replace with your management group's name
}

data "azurerm_virtual_network" "hub" {
  provider            = azurerm.connectivity
  name                = "vnet-hub-prod-uksouth-001"
  resource_group_name = "rg-hub-prod-uksouth-001"
}

data "azurerm_private_dns_zone" "existing_private_dns_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.dns_zone_resource_group_name
  provider            = azurerm.connectivity
}
