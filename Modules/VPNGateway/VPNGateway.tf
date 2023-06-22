// local-network-gateway
resource "azurerm_local_network_gateway" "local_network_gateway" {
  name = "local-ngw-${var.tags.ApplicationID}"
  resource_group_name = var.resourcegroup_name
  location = var.generalvars.location_long
  gateway_address = var.local_ngw.gateway_address
  address_space = var.local_ngw.address_space
}

resource "azurerm_public_ip" "vpn_pip" {
  name = "vpn-pbip"
  location = var.generalvars.location_long
  resource_group_name = var.resourcegroup_name

  allocation_method = var.ngw_public_ip.allocation_method
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name = "virtual-ngw-${var.tags.ApplicationID}"
  location = var.generalvars.location_long
  resource_group_name = var.resourcegroup_name

  type = var.virtual_ngw.type
  vpn_type = var.virtual_ngw.vpn_type

  active_active = var.virtual_ngw.active_active
  enable_bgp = var.virtual_ngw.enable_bgp
  sku = var.virtual_ngw.sku

  ip_configuration {
    name = "virtual-ngw-${var.tags.ApplicationID}-config"
    public_ip_address_id = azurerm_public_ip.vpn_pip.id
    private_ip_address_allocation = var.virtual_ngw_ip_configuration.private_ip_address_allocation
    subnet_id = var.subnet.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onprem" {
  name = "ngw-onprem-connection"
  location = var.generalvars.location_long
  resource_group_name = var.resourcegroup_name

  type = var.ngw_connection.type
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id = azurerm_local_network_gateway.local_network_gateway.id
  shared_key = var.ngw_connection.shared_key
}