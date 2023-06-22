resource "azurerm_resource_group" "Resource_Group" {
  count    = length(var.resourcegroup)
  name     = "RG-${upper(var.generalvars.client)}-${upper(var.generalvars.location_short)}-${upper(var.generalvars.environment)}-${upper(var.resourcegroup[count.index])}"
  # name     = "RG-Prueba-Back-0007"
  location = var.generalvars.location_long

  tags = merge(var.tags, { ResourceRole : "ResourceGroup" })
}