terraform {
  required_version = ">=1.3.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.25"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      detach_implicit_data_disk_on_deletion = false
      delete_os_disk_on_deletion            = true
      graceful_shutdown                     = false
      skip_shutdown_and_force_delete        = false
    }
  }
}
