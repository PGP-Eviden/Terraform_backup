variable "generalvars" {
  type        = map(any)
  description = "General Variables for compose names, location, etc."
}
variable "tags" {
  type        = map(any)
  description = "Resource Tags"
}
variable "resourcegroup" {
  type        = list(any)
  description = "Names for resource groups"
}
variable "vnet" {
  type        = map(any)
  description = "VNET settings"
}
variable "subnet" {
  type        = map(any)
  description = "Subnet settings"
}
variable "storageaccounts" {
  type        = map(any)
  description = "Storage Accounts"
}
variable "container" {
  type        = map(any)
  description = "Storage Accounts"
}
variable "sms_alerts" {
  type = list(object({
    country_code = string
    phone_number = string
    name = string
  }))
  description = "SMS alert phone numbers"
}
variable "email_alerts" {
  type = list(object({
    name = string
    email_address = string
  }))
  description = "Email alert phone numbers"
}

variable "metric_alerts" {
  type    = map(any) 
  description = "Metric alert parameters"
}

variable "local_ip" {
  type  = string
  default = null
}