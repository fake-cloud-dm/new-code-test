locals {
  #Tags
  tags = {
    "Application" = "${var.application}"
    "Criticality" = "${var.criticality}"
    "Environment" = "${var.environment}"
    "Owner"       = "${var.org}"
  }

  management_group_map = {
    "Customer"      = data.azurerm_management_group.customer.id
    "Platform"      = data.azurerm_management_group.platform.id
    "landing-zones" = data.azurerm_management_group.landing-zones.id
    "Connectivity"  = data.azurerm_management_group.connectivity.id
    "Management"    = data.azurerm_management_group.management.id
    "Identity"      = data.azurerm_management_group.identity.id
    "Corp"          = data.azurerm_management_group.corp.id
  }

  providers = {
    connectivity = "azurerm.connectivity"
    management   = "azurerm.management"
    identity     = "azurerm.identity"
    production   = "azurerm.production"
  }

  vnet_map_filtered_hub  = { for k, v in var.vnet_map : k => v if can(regex("hub", v.rg_name)) }
  vnet_map_filtered_mgmt = { for k, v in var.vnet_map : k => v if can(regex("mgmt", v.rg_name)) }
  vnet_map_filtered_adds = { for k, v in var.vnet_map : k => v if can(regex("adds", v.rg_name)) }
  vnet_map_filtered_prod = { for k, v in var.vnet_map : k => v if can(regex("prod", v.rg_name)) }

  snet_map_filtered_hub  = { for k, v in var.subnet_map : k => v if can(regex("hub", v.vnet_name)) }
  snet_map_filtered_mgmt = { for k, v in var.subnet_map : k => v if can(regex("mgmt", v.vnet_name)) }
  snet_map_filtered_adds = { for k, v in var.subnet_map : k => v if can(regex("adds", v.vnet_name)) }
  snet_map_filtered_prod = { for k, v in var.subnet_map : k => v if can(regex("prod", v.vnet_name)) }

  snet_map_filtered_all = merge(
    local.snet_map_filtered_hub,
    local.snet_map_filtered_mgmt,
    local.snet_map_filtered_adds,
    local.snet_map_filtered_prod,
  )

  # dns_zone_names = { for k, v in azurerm_private_dns_zone.dns_zone : k => v.name }

  vnet_ids = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : k => v.id },
    { for k, v in azurerm_virtual_network.vnet_management : k => v.id },
    { for k, v in azurerm_virtual_network.vnet_identity : k => v.id },
    { for k, v in azurerm_virtual_network.vnet_production : k => v.id },
  )

  vnet_names = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : k => v.name },
    { for k, v in azurerm_virtual_network.vnet_management : k => v.name },
    { for k, v in azurerm_virtual_network.vnet_identity : k => v.name },
    { for k, v in azurerm_virtual_network.vnet_production : k => v.name },
  )

  vnet_resource_groups = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : k => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_management : k => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_identity : k => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_production : k => v.resource_group_name },
  )

  # vnet_dns_links = flatten([
  #   for dns_key, dns_name in azurerm_private_dns_zone.dns_zone : [
  #     for vnet_key, vnet_id in local.vnet_ids : {
  #       dns_zone_name = dns_name.name
  #       vnet_id       = vnet_id
  #       key           = "${dns_key}_${vnet_key}"
  #       link_name     = "${vnet_key}-link-to-${dns_name.name}"
  #     }
  #   ]
  # ])

  vnets_uksouth = {
    hub = {
      name                = azurerm_virtual_network.vnet_connectivity["uksouth"].name
      resource_group_name = azurerm_virtual_network.vnet_connectivity["uksouth"].resource_group_name
      id                  = azurerm_virtual_network.vnet_connectivity["uksouth"].id
    }
    mgmt = {
      name                = azurerm_virtual_network.vnet_management["uksouth"].name
      resource_group_name = azurerm_virtual_network.vnet_management["uksouth"].resource_group_name
      id                  = azurerm_virtual_network.vnet_management["uksouth"].id
    }
    adds = {
      name                = azurerm_virtual_network.vnet_identity["uksouth"].name
      resource_group_name = azurerm_virtual_network.vnet_identity["uksouth"].resource_group_name
      id                  = azurerm_virtual_network.vnet_identity["uksouth"].id
    }
    prod = {
      name                = azurerm_virtual_network.vnet_production["uksouth"].name
      resource_group_name = azurerm_virtual_network.vnet_production["uksouth"].resource_group_name
      id                  = azurerm_virtual_network.vnet_production["uksouth"].id
    }
  }

  vnets_ukwest = {
    hub = {
      name                = azurerm_virtual_network.vnet_connectivity["ukwest"].name
      resource_group_name = azurerm_virtual_network.vnet_connectivity["ukwest"].resource_group_name
      id                  = azurerm_virtual_network.vnet_connectivity["ukwest"].id
    }
    mgmt = {
      name                = azurerm_virtual_network.vnet_management["ukwest"].name
      resource_group_name = azurerm_virtual_network.vnet_management["ukwest"].resource_group_name
      id                  = azurerm_virtual_network.vnet_management["ukwest"].id
    }
    adds = {
      name                = azurerm_virtual_network.vnet_identity["ukwest"].name
      resource_group_name = azurerm_virtual_network.vnet_identity["ukwest"].resource_group_name
      id                  = azurerm_virtual_network.vnet_identity["ukwest"].id
    }
    prod = {
      name                = azurerm_virtual_network.vnet_production["ukwest"].name
      resource_group_name = azurerm_virtual_network.vnet_production["ukwest"].resource_group_name
      id                  = azurerm_virtual_network.vnet_production["ukwest"].id
    }
  }


  location_short_map = {
    "uksouth" = "uks"
    "ukwest"  = "ukw"
  }

  prod_ukwest_map = {
    for loc in var.resource_group_map.production.locations : loc => {
      location = loc
      name     = "prod-ukwest"
    }
    if loc == "ukwest"
  }



  # vm_config_list = flatten([
  #   for as_key, as_value in var.avail_set_map : [
  #     for i in range(as_value.vm_count) : {
  #       availability_set = as_key
  #       vm_name          = format("vm-dc-%s-%03d", local.location_short_map[as_value.location], i + 1)
  #       location         = as_value.location
  #       rg_name          = azurerm_resource_group.rg_identity["adds-${as_value.location}"].name
  #       vnet_name        = "vnet-adds-${var.environment_short}-${as_value.location}-001"
  #       subnet_name      = "snet-adds-${var.environment_short}-${as_value.location}-001"
  #     }
  #   ]
  # ])

  vm_config_list = flatten([
    for as_key, as_value in var.avail_set_map : [
      for i in range(as_value.vm_count) : {
        availability_set = as_key
        vm_name          = format("vm-dc-%s-%03d", local.location_short_map[as_value.location], i + 1)
        location         = as_value.location
        rg_name          = azurerm_resource_group.rg_identity[as_value.location].name
        vnet_name        = azurerm_virtual_network.vnet_identity[as_value.location].name
        subnet_name      = format("snet-adds-%s-%s-001", var.environment_short, as_value.location)
      }
    ]
  ])


  # vm_mec_config_list = [
  #   for as_key, as_value in var.avail_set_map : {
  #     availability_set = as_key
  #     vm_name          = format("vm-mec-%s-%03d", local.location_short_map[as_value.location], 1)
  #     location         = as_value.location
  #     rg_name          = azurerm_resource_group.rg_identity["adds-${as_value.location}"].name
  #     vnet_name        = "vnet-adds-${var.environment_short}-${as_value.location}-001"
  #     subnet_name      = "snet-adds-${var.environment_short}-${as_value.location}-001"
  #   }
  # ]

  vm_mec_config_list = [
    for as_key, as_value in var.avail_set_map : {
      availability_set = as_key
      vm_name          = format("vm-mec-%s-%03d", local.location_short_map[as_value.location], 1)
      location         = as_value.location
      rg_name          = azurerm_resource_group.rg_identity[as_value.location].name
      vnet_name        = azurerm_virtual_network.vnet_identity[as_value.location].name
      subnet_name      = format("snet-adds-%s-%s-001", var.environment_short, as_value.location)
    }
  ]


  # vm_config_list_lm = flatten([
  #   for as_key, as_value in var.avail_set_map_lm : [
  #     for i in range(as_value.vm_count) : {
  #       availability_set = as_key
  #       vm_name          = format("vm-lm-%s-%03d", local.location_short_map[as_value.location], i + 1)
  #       location         = as_value.location
  #       rg_name          = azurerm_resource_group.rg_management["mgmt-${as_value.location}"].name
  #       vnet_name        = "vnet-mgmt-${var.environment_short}-${as_value.location}-001"
  #       subnet_name      = "snet-mgmt-${var.environment_short}-${as_value.location}-001"
  #     }
  #   ]
  # ])

  vm_config_list_lm = flatten([
    for as_key, as_value in var.avail_set_map_lm : [
      for i in range(as_value.vm_count) : {
        availability_set = as_key
        vm_name          = format("vm-lm-%s-%03d", local.location_short_map[as_value.location], i + 1)
        location         = as_value.location
        rg_name          = azurerm_resource_group.rg_management[as_value.location].name
        vnet_name        = azurerm_virtual_network.vnet_management[as_value.location].name
        subnet_name      = format("snet-mgmt-%s-%s-001", var.environment_short, as_value.location)
      }
    ]
  ])


  timezone_script = <<-EOT
    $timezone = "GMT Standard Time"
    Set-TimeZone -Name $timezone
    EOT

  mgmt_map = {
    for loc in var.resource_group_map.management.locations : loc => {
      location        = loc
      subscription_id = "management"
    }
  }

  adds_map = {
    for loc in var.resource_group_map.identity.locations : loc => {
      location        = loc
      subscription_id = "identity"
    }
  }

  prod_map = {
    for loc in var.resource_group_map.production.locations : loc => {
      location        = loc
      subscription_id = "production"
    }
  }

  filtered_storage_account_map = {
    for k, v in var.storage_account_map : k => v
    if v.location == var.location
  }
}

