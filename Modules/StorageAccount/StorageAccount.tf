resource "azurerm_storage_account" "StorageAccount" {
  count = length(var.storageaccounts)
  name  = "bak${lower(var.generalvars.client)}${var.tags.ApplicationID}"
  # name                     = "backprueba07"
  resource_group_name      = var.resourcegroup_name
  location                 = var.generalvars.location_long
  account_tier             = var.storageaccounts[count.index].account_tier
  account_replication_type = var.storageaccounts[count.index].account_replication_type
  account_kind             = var.storageaccounts[count.index].account_kind
  is_hns_enabled           = var.storageaccounts[count.index].is_hns_enabled
  access_tier              = var.storageaccounts[count.index].access_tier
  tags                     = merge(var.tags, { ResourceRole : "BackupStorage" })
  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "storageaccounts_Networkrules" {
  count                      = length(var.storageaccounts)
  storage_account_id         = azurerm_storage_account.StorageAccount[count.index].id
  default_action             = var.storageaccounts[count.index].ext_network_default
  virtual_network_subnet_ids = length(var.subnet) < 1 ? [] : [var.subnet[var.storageaccounts[count.index].allowed_subnet].id]
  ip_rules                   = concat(var.storageaccounts[count.index].ip_rules, var.local_ip != null ? [var.local_ip]:[])
  bypass                     = [var.storageaccounts[count.index].bypass]
}

resource "azurerm_storage_container" "Container" {
  count                 = length(var.container)
  name                  = var.container[count.index].name
  storage_account_name  = azurerm_storage_account.StorageAccount[var.container[count.index].storage_account].name
  container_access_type = var.container[count.index].access_type
}

resource "azurerm_storage_management_policy" "example" {
  count              = length(var.storageaccounts)
  storage_account_id = azurerm_storage_account.StorageAccount[count.index].id

  rule {
    name    = "policy-${azurerm_storage_account.StorageAccount[count.index].name}"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_creation_greater_than            = 0
        tier_to_archive_after_days_since_last_access_time_greater_than = 0
        #delete_after_days_since_modification_greater_than              = 365
      }
    }
  }
}
