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
}
variable "subnet" {
  type = any
}

variable "local_ngw" {
 type = object({
  gateway_address = string
  address_space = set(string)
 })
}

variable "ngw_public_ip" {
  type = map(any)
}

variable "virtual_ngw" {
  type = map(any)
}
variable "virtual_ngw_ip_configuration" {
  type = map(any)
}

variable "ngw_connection" {
  type = map(any)
}