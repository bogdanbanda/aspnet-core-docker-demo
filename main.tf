# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.16.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  subscription_id = "af59a50c-7a7b-4815-b615-641990427b44"
  client_id     = "2f78554c-91fd-424f-aade-aaa3af7cc2db"
  client_secret = "xOZ8Q~hAEXHCDbqK.eRXE5wJ2RRfWulnjhFg1bkB"
  tenant_id     = "a047dbfb-d5eb-47f3-8d21-381786ab6c80"

}

resource "azurerm_container_registry" "BoBacr" {
  name                     = "BoBacr"
  resource_group_name      = "BoBaRG"
  location                 = "West Europe"
  sku                      = "Basic"
  admin_enabled            = true
}

resource "azurerm_service_plan" "BoBaASP" {  
  name                = "BoBaASP"  
  location            = "West Europe"
  resource_group_name = "BoBaRG"  
  os_type             = "Linux"
  sku_name            = "S1"
}   

resource "azurerm_linux_web_app" "BoBaWEB" {  
  name                = "BoBaWEB"  
  location            = "West Europe"
  resource_group_name = "BoBaRG" 

  service_plan_id = azurerm_service_plan.BoBaASP.id

  app_settings = {
     "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
      DOCKER_REGISTRY_SERVER_USERNAME = "BoBacr"
      DOCKER_REGISTRY_SERVER_URL = "bobacr.azurecr.io"
      DOCKER_REGISTRY_SERVER_PASSWORD = "aT6kUnh+tng4iJnotl6x1tDzQUO/jF+i"
      DOCKER_ENABLE_CI = "true"
    }

  site_config {

    application_stack {
      docker_image     = "bobadock"
      docker_image_tag = "latest" 
     }
  }
}  