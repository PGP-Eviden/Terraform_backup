resource "azurerm_virtual_network" "Vnet" {
  count               = length(var.vnet)
  name                = "vnet-${lower(var.generalvars.client)}-${lower(var.generalvars.location_short)}-${lower(var.generalvars.environment)}-${var.tags.ApplicationID}"
  location            = var.generalvars.location_long
  resource_group_name = var.resourcegroup_name
  tags                = merge(var.tags, { ResourceRole : "VirtualNetwork" })
  address_space       = var.vnet[count.index].vnet_address
}

resource "azurerm_subnet" "Subnet" {
  resource_group_name                            = var.resourcegroup_name
  for_each                                       = var.subnet
  virtual_network_name                           = azurerm_virtual_network.Vnet[each.value.vnet_id].name
  # name                                           = "subnet-${lower(var.generalvars.client)}-${lower(var.generalvars.location_short)}-${lower(var.generalvars.environment)}-${var.tags.ApplicationID}"
  name                                           = "GatewaySubnet"
  address_prefixes                               = each.value.subnet_address
  private_endpoint_network_policies_enabled      = each.value.subnet_plink
  service_endpoints                              = each.value.subnet_endp
}
