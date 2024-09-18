terraform {
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
  cloud {
    # The cloud block is used for connecting to the Terraform Cloud remote backend
    organization = ""
    workspaces {
      # Mutliple workspaces can be defined here
      tags = [
        # Tags can be used to filter workspaces in the Terraform Cloud
        ""
      ]
    }
  }
  required_version = ">= 1.9.0"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

