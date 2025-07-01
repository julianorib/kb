terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  features {}
}

## Criar um Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.projeto
  location = var.regiao
  tags     = merge({ Name = format("%s-rg", var.projeto) }, local.common_tags)
}
