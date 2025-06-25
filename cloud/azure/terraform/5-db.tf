resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = "pg-web-backend"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  administrator_login    = "pgadmin"
  administrator_password = "PgStrongP@ss123"
  storage_mb             = 32768
  sku_name               = "B1ms"
  zone                   = "1"

  delegated_subnet_id = azurerm_subnet.subnet.id
  private_dns_zone_id = null

  high_availability {
    mode = "ZoneRedundant"
  }
}
