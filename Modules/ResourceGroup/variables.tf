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
  description = "Names for all resource groups"
}