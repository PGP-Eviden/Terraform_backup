#General Vars
generalvars = {
  location_long  = "westeurope"
  location_short = "euw"
  environment    = "p"
  prefix         = "I66-BI-PRO"
  client         = "client"
}

#Tags
tags = {
  Environment     = "Pro",
  ProductOwner    = "Eviden",
  Criticalicity   = "1",
  Department      = "IT",
  ApplicationID   = "0005",
  Developers      = "Eviden",
  CloudArchitect  = "EvidenArchitecture",
  Lock            = "No",
  Confidentiality = "Private",
  Region          = "westeurope"
}

#ResourceGroup
resourcegroup = ["05"]

#Storage Account
storageaccounts = {
  0 = {
    "account_tier"             = "Standard",
    "account_replication_type" = "LRS",
    "account_kind"             = "StorageV2",
    "is_hns_enabled"           = "true",
    "ext_network_default"      = "Deny",
    # "ext_network_default"      = "Allow" // No permite reutilizar/borrar con Deny
    "allowed_subnet"  = "0"
    "bypass"          = "AzureServices"
    "endpoint_subnet" = "0"
    "access_tier"     = "Cool"
    "ip_rules"        = ["147.161.190.184", "136.226.215.86", "165.225.93.30"]
  },
}

container = {
  0 = {
    "storage_account" = "0"
    "name"            = "cont-bak-pro",
    "access_type"     = "private"
  },
  1 = {
    "storage_account" = "0"
    "name"            = "cont-bak-dev",
    "access_type"     = "private"
  },
  # 1 = {
  #   "storage_account" = "0"
  #   "name"            = "cont-bak-dev",
  #   "access_type"     = "private"
  # }
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
    email_address = "usuario@example.net"
    name          = "email_alert_backup"
  }
]

sms_alerts = [
  {
    name         = "sms_alert_backup"
    country_code = "34"
    phone_number = "912345678"
  },
  # {
  #   name = "client2"
  #   country_code = "34"
  #   phone_number = "901321321"

  # }
]
