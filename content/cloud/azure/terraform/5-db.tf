## Criar uma Zona DNS Privada para o MySQL (obrigatório)
resource "azurerm_private_dns_zone" "main" {
  name                = "${var.projeto}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

## Associnar a Zona DNS Privada a VNET
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = format("%s-dns-zone-link", var.projeto)
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
}

## Criar uma Instância de Banco de dados Mysql
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = var.projeto
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "mysqladmin"
  administrator_password = "H@Sh1CoR3!"
  backup_retention_days  = 7
  version                = "8.0.21"
  delegated_subnet_id    = azurerm_subnet.subnet3.id
  private_dns_zone_id    = azurerm_private_dns_zone.main.id
  sku_name               = "B_Standard_B2ms"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.main]
  tags       = merge({ Name = format("%s-mysql", var.projeto) }, local.common_tags)
}