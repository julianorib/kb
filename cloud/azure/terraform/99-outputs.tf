output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "postgres_host" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
}

output "storage_account" {
  value = azurerm_storage_account.storage.name
}
