# Resource Group
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  #value       = local.resource_group_name
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  #value       = azurerm_resource_group.rg[count.index].id
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  #value       = local.location
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

#asp
output "app_service_plan_id" {
  description = "The id of the app service plan"
  #value       = azurerm_app_service_plan.asp[count.index].id
  #value       = element(concat(azurerm_app_service_plan.asp.*.id, [""]), 0)
  value       = flatten(concat([for s in azurerm_app_service_plan.asp : s.id]))
}
