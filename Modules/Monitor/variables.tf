variable "storageaccount" {
  type = any
  description = "Storage Account"
}
variable "resourcegroup_name" {
  type        = string
}
variable "generalvars" {
  type        = map(any)
  description = "General Variables for compose names, location, etc."
}
variable "tags" {
  type        = map(any)
  description = "Resource Tags"
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