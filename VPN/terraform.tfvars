#General Vars
generalvars = {
  location_long  = "westeurope"
  location_short = "euw"
  environment    = "p"
  client         = "client"
}

#Tags
tags = {
  Environment     = "Pro",
  ProductOwner    = "Eviden",
  Criticalicity   = "1",
  Department      = "IT",
  ApplicationID   = "0001",
  Developers      = "Eviden",
  CloudArchitect  = "EvidenArchitecture",
  Lock            = "No",
  Confidentiality = "Private",
  Region          = "westeurope"
}

#ResourceGroup
resourcegroup = ["01"]

#Network
vnet = {
  0 = {
    "vnet_address" = ["10.43.18.0/24"]
  }
}
  
subnet = {
  0 = {
    "vnet_id"            = "0"
    "subnet_address"     = ["10.43.18.0/26"],
    "subnet_plink"       = "true",
    "subnet_endp"        = ["Microsoft.Storage"],
  }
}

#Storage Account
storageaccounts = {
  0 = {
    "account_tier"             = "Standard",
    "account_replication_type" = "LRS",
    "account_kind"             = "StorageV2",
    "is_hns_enabled"           = "true",
    "ext_network_default"      = "Deny"
    "allowed_subnet"           = "0"
    "bypass"                   = "AzureServices"
    "endpoint_subnet"          = "0"
    "access_tier"              = "Cool"
    # "ip_rules"                 = ["147.161.190.184"]
    "ip_rules"                 = []
  },
}

container = {
  0 = {
    "storage_account" = "0"
    "name"            = "cont-bak-01",
    "access_type"     = "private"
  },
  1 = {
    "storage_account" = "0"
    "name"            = "cont-bak-dev",
    "access_type"     = "private"
  }
}

metric_alerts = {

  storage_account_id = 0,
  threshold          = 3145728,
  window_size        = "PT1H",
  frequency          = "PT5M",
  severity           = 3,
  description_amount = "3MB"

}

# Añadir alertas
email_alerts = [
  {
    email_address = "cliente@cliente.es"
    name        = "email_alert_backup"
  } 
]

sms_alerts = [
  {
    name = "sms_alert_backup"
    country_code = "34"
    phone_number = "900123123"
  },
  # {
  #   name = "client2"
  #   country_code = "34"
  #   phone_number = "901512345"

  # }
]

local_ngw = {
  gateway_address  = "4.3.2.1",
  address_space = ["10.1.0.0/24"]
}

ngw_public_ip = {
  allocation_method = "Dynamic"
}

virtual_ngw = {
  type = "Vpn",
  vpn_type = "RouteBased",
  active_active = false,
  enable_bgp = false,
  sku = "VpnGw1"
}

virtual_ngw_ip_configuration = {
  private_ip_address_allocation = "Dynamic"
}

ngw_connection = {
  type = "IPsec",
  shared_key = "4-v3rx-53cr37-1p73c-5h4r3d-k4y"
}