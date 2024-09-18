variable "location" {
  description = "Location of the resource"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Name of the environment of the resources"
  type        = string
}

variable "default_tags" {
  type        = map(string)
  description = "set of default tags to apply everywhere"
}

# Azure function app

# Some variables, like these 3 below, are defined in the workspace 
# and injected when running the Terraform commands
variable "MAILJET_API_KEY" {
  description = "API key for the Mailjet service"
  type        = string
  sensitive   = true
}

variable "MAILJET_SECRET_KEY" {
  description = "API secret for the Mailjet service"
  type        = string
  sensitive   = true
}

variable "MAILJET_SENDER_MAIL" {
  description = "Sender email for the Mailjet service"
  type        = string
}

# Storage account

variable "sa_tier" {
  description = "Tier of the storage account"
  type        = string
}

variable "sa_replication_type" {
  description = "Replication type of the storage account"
  type        = string
}
