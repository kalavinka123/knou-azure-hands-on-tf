terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.67.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "knou_mall_rg" {
  name     = "KNOU_MALL"
  location = "Japan East"
}

resource "azurerm_virtual_network" "knou_mall_vnet" {
  name                = "mall-vm1-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.knou_mall_rg.location
  resource_group_name = azurerm_resource_group.knou_mall_rg.name
}

resource "azurerm_subnet" "knou_mall_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.knou_mall_rg.name
  virtual_network_name = azurerm_virtual_network.knou_mall_vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  service_endpoints = ["Microsoft.KeyVault"] ## 키 자격 증명을 위한 세팅
}

module "step1" {
  source = "./modules/course4"
  knou_mall_rg = azurerm_resource_group.knou_mall_rg
  knou_mall_subnet = azurerm_subnet.knou_mall_subnet
  my_ip = var.my_ip
  tags = var.tags
}

module "step2" {
  source = "./modules/course5"
  knou_mall_rg = azurerm_resource_group.knou_mall_rg
  my_ip = var.my_ip
  db_server_name = var.db_server_name
  db_admin_password = var.db_admin_password
  tags = var.tags
}

module "step3" {
  source = "./modules/course6"
  knou_mall_rg = azurerm_resource_group.knou_mall_rg
  my_ip = var.my_ip
  knou_mall_subnet = azurerm_subnet.knou_mall_subnet
  key_vault_name = var.key_vault_name
  key_vault_secret_name = var.key_vault_secret_name
  key_vault_secret_password = var.key_vault_secret_password
  tags = var.tags
}
