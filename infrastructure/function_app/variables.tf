variable "source_directory" {
  type        = string
  description = "Directory containing the function app to be zipped and deployed"
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  nullable    = true # This makes the variable optional
  default     = {}
}

variable "location" {
  type        = string
  description = "Location of the resources"
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  nullable    = false
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  nullable    = true
  default     = null
}

variable "function_app_name" {
  type        = string
  description = "Name of the function app"
  nullable    = true
  default     = null
}

variable "function_app_settings" {
  type        = map(string)
  description = "Settings to apply to the function app"
  # Sensitive variables are not shown in the output
  # These settings might contain a connection string or a secret so must not be shown
  sensitive   = true  
  nullable    = true
  default     = {}
}

