terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.56.0"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}


#------------------------
# Local declarations
#------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  #location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  location    = var.location
}

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = local.location
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
}



resource "azurerm_app_service_plan" "asp" {
  for_each                     = var.app_service_plans

  name                         = each.value.asp_name
  location                     = local.location
  resource_group_name          = local.resource_group_name
  kind                         = each.value.kind
  maximum_elastic_worker_count = lookup(each.value, "maximum_elastic_worker_count", null)

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = lookup(each.value, "reserved", null) == null ? null : each.value.reserved
  per_site_scaling = lookup(each.value.sku, "per_site_scaling", false)
  is_xenon         = lookup(each.value, "is_xenon", null)

  sku {
    tier     = each.value.sku.tier
    size     = each.value.sku.size
    capacity = lookup(each.value.sku, "capacity", null)
  }

  #app_service_environment_id = var.app_service_environment_id
  tags                       = var.tags

  timeouts {
    create = "5h"
    update = "5h"
  }

#   lifecycle {
#     # TEMP until native tf provider for ASE ready to avoid force replacement of asp on every ase changes
#     ignore_changes = [app_service_environment_id]
#   }
}

