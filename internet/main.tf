terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.33"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
  }
}

# Mirar lifecycle de container e ips
provider "azurerm" {
  features {}

  # problema con el registro
  skip_provider_registration = true
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

locals {
  ifconfig = data.http.ip.response_body
}

module "ResourceGroup" {
  source        = "../Modules/ResourceGroup"
  generalvars   = var.generalvars
  resourcegroup = var.resourcegroup
  tags          = var.tags
}


module "StorageAccount" {
  source             = "../Modules/StorageAccount"
  generalvars        = var.generalvars
  resourcegroup_name = module.ResourceGroup.ResourceGroup[0].name
  storageaccounts    = var.storageaccounts
  local_ip           = local.ifconfig
  subnet             = {}
  container          = var.container
  tags               = var.tags

  # depends_on = [module.ResourceGroup]
}

module "Monitor" {
  source             = "../Modules/Monitor"
  generalvars        = var.generalvars
  tags               = var.tags
  storageaccount     = module.StorageAccount.StorageAccount
  resourcegroup_name = module.ResourceGroup.ResourceGroup[0].name
  sms_alerts         = var.sms_alerts
  email_alerts       = var.email_alerts
  metric_alerts      = var.metric_alerts
  depends_on         = [module.StorageAccount]
}
