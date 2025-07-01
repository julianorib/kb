## Criar uma VNET
resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet", var.projeto)
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = merge({ Name = format("%s-vnet", var.projeto) }, local.common_tags)
}

## Criar uma Subnet para VMSS
resource "azurerm_subnet" "subnet1" {
  name                 = format("%s-subnet-1", var.projeto)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  #tags = merge({ Name = format("%s-subnet-1", var.projeto) }, local.common_tags)
}

## Criar uma Subnet para VM Linux
resource "azurerm_subnet" "subnet2" {
  name                 = format("%s-subnet-2", var.projeto)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  #tags = merge({ Name = format("%s-subnet-2", var.projeto) }, local.common_tags)
}

## Criar uma Subnet para Mysql
resource "azurerm_subnet" "subnet3" {
  name                 = format("%s-subnet-3", var.projeto)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "delegation-mysql-flexible"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}


## Criar um IP público para o NAT Gateway
resource "azurerm_public_ip" "nat_ip" {
  name                = format("%s-public-ip-nat-gateway", var.projeto)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge({ Name = format("%s-public-ip-nat-gateway", var.projeto) }, local.common_tags)
}

## Criar o NAT Gateway
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = format("%s-nat-gateway", var.projeto)
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = merge({ Name = format("%s-nat-gateway", var.projeto) }, local.common_tags)
}

## Associar o NAT Gateway à sub-rede onde está o VMSS
resource "azurerm_subnet_nat_gateway_association" "nat_assoc" {
  subnet_id      = azurerm_subnet.subnet1.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

## Associar o IP público ao NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_ip" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

