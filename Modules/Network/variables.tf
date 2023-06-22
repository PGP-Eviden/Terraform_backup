variable "generalvars" {
  type        = map(any)
  description = "General Variables for compose names, location, etc."
}
variable "tags" {
  type        = map(any)
  description = "Resource Tags"
}
variable "resourcegroup_name" {
  type        = string
  description = "Resource Group name"
}
variable "vnet" {
  type        = map(any)
  description = "VNET settings"
}
variable "subnet" {
  type        = map(any)
  description = "Subnet settings"
}