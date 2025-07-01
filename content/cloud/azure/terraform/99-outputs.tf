output "IP_do_LoadBalancer" {
  value = azurerm_public_ip.lb_ip.ip_address
}

output "DB_Endpoint" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "DB_user" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "DB_password" {
  value = azurerm_mysql_flexible_server.mysql.administrator_password
  sensitive = true
}