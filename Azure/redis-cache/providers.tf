terraform {
  required_version = "~> 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }

    modtm = {
      source  = "Azure/modtm"
      version = "~> 0.3"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "b8247bfa-b1b7-4a08-82cb-39d0fcb27b01"
  tenant_id       = "26341a5a-680d-4158-9551-557ee36ca55b"
}
