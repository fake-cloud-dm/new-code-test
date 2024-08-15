# resource "azurerm_virtual_network" "vnet_connectivity" {
#   for_each            = local.vnet_map_filtered_hub
#   address_space       = [each.value.address_space]
#   name                = lower("vnet-hub-${var.environment_short}-${each.value.location}-001")
#   location            = azurerm_resource_group.rg_connectivity[each.value.rg_name].location
#   resource_group_name = azurerm_resource_group.rg_connectivity[each.value.rg_name].name
#   dns_servers         = each.value.location == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
#   tags                = local.tags
#   provider            = azurerm.connectivity
# }

# resource "azurerm_virtual_network" "vnet_management" {
#   for_each            = local.vnet_map_filtered_mgmt
#   address_space       = [each.value.address_space]
#   name                = lower("vnet-mgmt-${var.environment_short}-${each.value.location}-001")
#   location            = azurerm_resource_group.rg_management[each.value.rg_name].location
#   resource_group_name = azurerm_resource_group.rg_management[each.value.rg_name].name
#   dns_servers         = each.value.location == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
#   tags                = local.tags
#   provider            = azurerm.management
# }

# resource "azurerm_virtual_network" "vnet_identity" {
#   for_each            = local.vnet_map_filtered_adds
#   address_space       = [each.value.address_space]
#   name                = lower("vnet-adds-${var.environment_short}-${each.value.location}-001")
#   location            = azurerm_resource_group.rg_identity[each.value.rg_name].location
#   resource_group_name = azurerm_resource_group.rg_identity[each.value.rg_name].name
#   dns_servers         = each.value.location == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
#   tags                = local.tags
#   provider            = azurerm.identity
# }

# resource "azurerm_virtual_network" "vnet_production" {
#   for_each            = local.vnet_map_filtered_prod
#   address_space       = [each.value.address_space]
#   name                = lower("vnet-prod-${each.value.location}-001")
#   location            = azurerm_resource_group.rg_production[each.value.rg_name].location
#   resource_group_name = azurerm_resource_group.rg_production[each.value.rg_name].name
#   dns_servers         = each.value.location == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
#   tags                = local.tags
#   provider            = azurerm.production
# }

resource "azurerm_virtual_network" "vnet_connectivity" {
  for_each            = { for loc, addr in var.vnet_map.hub.address_spaces : loc => addr }
  address_space       = [each.value]
  name                = lower("vnet-hub-${var.environment_short}-${each.key}-001")
  location            = each.key
  resource_group_name = azurerm_resource_group.rg_connectivity[each.key].name
  dns_servers         = each.key == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
  tags                = local.tags
  provider            = azurerm.connectivity
}

resource "azurerm_virtual_network" "vnet_management" {
  for_each            = { for loc, addr in var.vnet_map.mgmt.address_spaces : loc => addr }
  address_space       = [each.value]
  name                = lower("vnet-mgmt-${var.environment_short}-${each.key}-001")
  location            = each.key
  resource_group_name = azurerm_resource_group.rg_management[each.key].name
  dns_servers         = each.key == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
  tags                = local.tags
  provider            = azurerm.management
}

resource "azurerm_virtual_network" "vnet_identity" {
  for_each            = { for loc, addr in var.vnet_map.adds.address_spaces : loc => addr }
  address_space       = [each.value]
  name                = lower("vnet-adds-${var.environment_short}-${each.key}-001")
  location            = each.key
  resource_group_name = azurerm_resource_group.rg_identity[each.key].name
  dns_servers         = each.key == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
  tags                = local.tags
  provider            = azurerm.identity
}

resource "azurerm_virtual_network" "vnet_production" {
  for_each            = { for loc, addr in var.vnet_map.prod.address_spaces : loc => addr }
  address_space       = [each.value]
  name                = lower("vnet-prod-${each.key}-001")
  location            = each.key
  resource_group_name = azurerm_resource_group.rg_production[each.key].name
  dns_servers         = each.key == "uksouth" ? [var.fw_uksouth_ip] : [var.fw_ukwest_ip]
  tags                = local.tags
  provider            = azurerm.production
}
