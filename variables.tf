variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  #default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "East US2"
}

variable "app_service_plans" {
  description = "For each app_service_plan, create an object that contain fields"
  default     = {}
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map(any)
}