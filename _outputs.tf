# output "dns_zone_ids" {
#   value = {
#     for k, v in azurerm_private_dns_zone.dns_zone : k => v.id
#   }
# }

output "vnet_ids" {
  value = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : "${k}-connectivity" => v.id },
    { for k, v in azurerm_virtual_network.vnet_management : "${k}-mgmt" => v.id },
    { for k, v in azurerm_virtual_network.vnet_identity : "${k}-adds" => v.id },
    { for k, v in azurerm_virtual_network.vnet_production : "${k}-prod" => v.id }
  )
}


output "vnet_names" {
  value = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : "${k}-connectivity" => v.name },
    { for k, v in azurerm_virtual_network.vnet_management : "${k}-mgmt" => v.name },
    { for k, v in azurerm_virtual_network.vnet_identity : "${k}-adds" => v.name },
    { for k, v in azurerm_virtual_network.vnet_production : "${k}-prod" => v.name }
  )
}



output "vnet_resource_groups" {
  value = merge(
    { for k, v in azurerm_virtual_network.vnet_connectivity : "${k}-connectivity" => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_management : "${k}-mgmt" => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_identity : "${k}-adds" => v.resource_group_name },
    { for k, v in azurerm_virtual_network.vnet_production : "${k}-prod" => v.resource_group_name }
  )
}


# output "firewall_ip_configurations" {
#   value = {
#     for loc, v in azurerm_firewall.firewall : loc => v.ip_configuration[0].private_ip_address
#   }
# }


output "vm_config_map" {
  value = local.vm_config_list
}

