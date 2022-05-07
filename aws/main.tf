terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
        source = "hashicorp/aws"
        version = "3.65.0"
    }
  }
}