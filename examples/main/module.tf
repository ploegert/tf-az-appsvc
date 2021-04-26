
locals {

  naming_product = "obt"
  naming_component = "core"
  naming_env = "z"
  naming_project = ""
  naming_zone = "z2"
 
  prefix = ["${local.naming_product}${local.naming_env}${local.naming_zone}", "asp" ]

  global_settings = {
    region_primary      = "East US2"
    region_secondary    = "eastus"
    prefix              = local.prefix
    suffix              = [ ]

    core_rg             = module.naming.resource_group.name
    core_vnet_name      = module.naming.virtual_network.name
  }
}

module "naming" {
  # source  = "github.com/Azure/terraform-azurerm-naming"
  source  = "github.com/ploegert/terraform-azurerm-naming"

  prefix = local.prefix
  suffix = [ ]
}


module "test_as" {
  source  = "../../"
  
  create_resource_group          = true
  resource_group_name            = local.global_settings.core_rg
  location                       = lookup(local.global_settings, "region_primary", "East US2")
  

  app_service_plans = {
    core = {
      asp_name                      = module.naming.app_service_plan.name
      kind                          = "elastic" # windows/app/Linux, elastic, functionApp
      maximum_elastic_worker_count  = 20        # 
      is_xenon                      = false     # [False]/True - only true on Wdinws Contaienr
      
      # if kind = linux, reserved must = true
      # if kind = windows/app, reserved must = false
      reserved                      = false     # [False]/True 

      sku = {
        tier                        = "ElasticPremium"
        size                        = "EP1"
        capacity                    = 1
      }
      

    }
  }

  # Adding TAG's to your Azure resources (Required)
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
