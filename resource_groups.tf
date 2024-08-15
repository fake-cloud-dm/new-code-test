# resource "azurerm_resource_group" "rg_connectivity" {
#   for_each = { for k, v in var.resource_group_map : k => v if v.subscription_id == "connectivity" }
#   name     = lower("rg-hub-${var.environment_short}-${each.value.location}-001")
#   location = each.value.location
#   tags     = local.tags
#   provider = azurerm.connectivity
# }

# resource "azurerm_resource_group" "rg_management" {
#   for_each = { for k, v in var.resource_group_map : k => v if v.subscription_id == "management" }
#   name     = lower("rg-mgmt-${var.environment_short}-${each.value.location}-001")
#   location = each.value.location
#   tags     = local.tags
#   provider = azurerm.management
# }

# resource "azurerm_resource_group" "rg_identity" {
#   for_each = { for k, v in var.resource_group_map : k => v if v.subscription_id == "identity" }
#   name     = lower("rg-adds-${var.environment_short}-${each.value.location}-001")
#   location = each.value.location
#   tags     = local.tags
#   provider = azurerm.identity
# }

# resource "azurerm_resource_group" "rg_production" {
#   for_each = { for k, v in var.resource_group_map : k => v if v.subscription_id == "production" }
#   name     = lower("rg-prod-${each.value.location}-001")
#   location = each.value.location
#   tags     = local.tags
#   provider = azurerm.production
# }

resource "azurerm_resource_group" "rg_connectivity" {
  for_each = { for loc in var.resource_group_map.connectivity.locations : loc => loc }
  name     = lower("rg-hub-${var.environment_short}-${each.value}-001")
  location = each.value
  tags     = local.tags
  provider = azurerm.connectivity
}

resource "azurerm_resource_group" "rg_management" {
  for_each = { for loc in var.resource_group_map.management.locations : loc => loc }
  name     = lower("rg-mgmt-${var.environment_short}-${each.value}-001")
  location = each.value
  tags     = local.tags
  provider = azurerm.management
}

resource "azurerm_resource_group" "rg_identity" {
  for_each = { for loc in var.resource_group_map.identity.locations : loc => loc }
  name     = lower("rg-adds-${var.environment_short}-${each.value}-001")
  location = each.value
  tags     = local.tags
  provider = azurerm.identity
}

resource "azurerm_resource_group" "rg_production" {
  for_each = { for loc in var.resource_group_map.production.locations : loc => loc }
  name     = lower("rg-prod-${each.value}-001")
  location = each.value
  tags     = local.tags
  provider = azurerm.production
}
