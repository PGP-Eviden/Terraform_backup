terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.33"
    }
  }
}

provider "azurerm" {
  features {}

  # problema con el registro
  skip_provider_registration = true
}

module "ResourceGroup" {
  source        = "../Modules/ResourceGroup"
  generalvars   = var.generalvars
  resourcegroup = var.resourcegroup
  tags          = var.tags
}

module "Network" {
  source             = "../Modules/Network"
  generalvars        = var.generalvars
  resourcegroup_name = module.ResourceGroup.ResourceGroup[0].name
  vnet               = var.vnet
  subnet             = var.subnet
  tags               = var.tags
  # depends_on = [module.ResourceGroup]
}



module "StorageAccount" {
  source             = "../Modules/StorageAccount"
  generalvars        = var.generalvars
  resourcegroup_name = module.ResourceGroup.ResourceGroup[0].name
  storageaccounts    = var.storageaccounts
  subnet             = module.Network.Subnet
  container          = var.container
  tags               = var.tags
  local_ip           = var.local_ip

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
