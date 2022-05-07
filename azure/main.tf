terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.5.0"
    }
  }
}

provider "azurerm" {
    features {}   
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type = string
}

variable "app_service_plan_name" {
  description = "Name of the app service plan"
  type = string
}

variable "web_app_name" {
  description = "Name of the web app"
  type = string
}

variable "owner" {
  description = "Owner of the resource group"
  type = string
}

locals {
  resource_group_name = "${var.owner}-${var.resource_group_name}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = "eastus"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_service_plan.app_service_plan.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {}
}

output "web_app_id" {
  value = azurerm_linux_web_app.web_app.id
}