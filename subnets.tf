# resource "azurerm_subnet" "subnet_connectivity" {
#   for_each             = local.snet_map_filtered_hub
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = lower("snet-${each.value.name}-${var.environment_short}-${each.value.location}-001")
#   resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].name
#   provider             = azurerm.connectivity
# }

# resource "azurerm_subnet" "subnet_management" {
#   for_each             = local.snet_map_filtered_mgmt
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = lower("snet-${each.value.name}-${var.environment_short}-${each.value.location}-001")
#   resource_group_name  = azurerm_virtual_network.vnet_management[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_management[each.value.vnet_name].name
#   provider             = azurerm.management
# }

# resource "azurerm_subnet" "subnet_identity" {
#   for_each             = local.snet_map_filtered_adds
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = lower("snet-${each.value.name}-${var.environment_short}-${each.value.location}-001")
#   resource_group_name  = azurerm_virtual_network.vnet_identity[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_identity[each.value.vnet_name].name
#   provider             = azurerm.identity
# }

# resource "azurerm_subnet" "subnet_production" {
#   for_each             = local.snet_map_filtered_prod
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = lower("snet-${each.value.name}-${each.value.location}-001")
#   resource_group_name  = azurerm_virtual_network.vnet_production[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_production[each.value.vnet_name].name
#   provider             = azurerm.production
# }

# resource "azurerm_subnet" "AzureFirewallSubnet" {
#   for_each             = var.firewall_subnet_map
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = "AzureFirewallSubnet"
#   resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].name
#   provider             = azurerm.connectivity
# }

# resource "azurerm_subnet" "AzureFirewallManagementSubnet" {
#   for_each             = var.firewall_mgmt_subnet_map
#   address_prefixes     = [each.value.address_prefixes]
#   name                 = "AzureFirewallManagementSubnet"
#   resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.value.vnet_name].name
#   provider             = azurerm.connectivity
# }

resource "azurerm_subnet" "subnet_connectivity" {
  for_each             = { for loc, subnet in var.subnet_map.adds.subnets : loc => subnet }
  address_prefixes     = [each.value.address_prefixes]
  name                 = lower("snet-adds-${var.environment_short}-${each.key}-001")
  resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.key].name
  provider             = azurerm.connectivity
}

resource "azurerm_subnet" "subnet_management" {
  for_each             = { for loc, subnet in var.subnet_map.mgmt.subnets : loc => subnet }
  address_prefixes     = [each.value.mgmt_address_prefixes]
  name                 = lower("snet-mgmt-${var.environment_short}-${each.key}-001")
  resource_group_name  = azurerm_virtual_network.vnet_management[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_management[each.key].name
  provider             = azurerm.management
}

resource "azurerm_subnet" "subnet_identity" {
  for_each             = { for loc, subnet in var.subnet_map.adds.subnets : loc => subnet }
  address_prefixes     = [each.value.peps_address_prefixes]
  name                 = lower("snet-peps-adds-${var.environment_short}-${each.key}-001")
  resource_group_name  = azurerm_virtual_network.vnet_identity[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_identity[each.key].name
  provider             = azurerm.identity
}

resource "azurerm_subnet" "subnet_production" {
  for_each             = { for loc, subnet in var.subnet_map.prod.subnets : loc => subnet }
  address_prefixes     = [each.value.prod_address_prefixes]
  name                 = lower("snet-prod-${each.key}-001")
  resource_group_name  = azurerm_virtual_network.vnet_production[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_production[each.key].name
  provider             = azurerm.production
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  for_each             = { for loc, subnet in var.firewall_subnet_map.hub.subnets : loc => subnet }
  address_prefixes     = [each.value.firewall_subnet_address_prefixes]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.key].name
  provider             = azurerm.connectivity
}

resource "azurerm_subnet" "AzureFirewallManagementSubnet" {
  for_each             = { for loc, subnet in var.firewall_subnet_map.hub.subnets : loc => subnet }
  address_prefixes     = [each.value.firewall_mgmt_subnet_address_prefixes]
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_virtual_network.vnet_connectivity[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_connectivity[each.key].name
  provider             = azurerm.connectivity
}
