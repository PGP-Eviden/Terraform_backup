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
variable "storageaccounts" {
  type        = map(any)
  description = "Storage Accounts"
}
variable "subnet" {
  type        = map(any)
  description = "Subnet settings"
}
variable "container" {
  type        = map(any)
  description = "Storage Accounts"
}

variable "local_ip" {
  type = string 
  description = "local ip config"
}