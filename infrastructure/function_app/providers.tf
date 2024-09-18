terraform {
  # Extra providers in the module can be defined in a terraform block
  # This is not required but can be useful to ensure the correct versions are used
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
  }
}
