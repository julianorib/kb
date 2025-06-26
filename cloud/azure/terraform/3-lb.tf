## Criar um LoadBalancer
resource "azurerm_lb" "lb" {
  name                = format("%s-loadbalancer", var.projeto)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIP"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
  tags = merge({ Name = format("%s-loadbalancer", var.projeto) }, local.common_tags)
}

## Criar um IP Publico para o LoadBalancer
resource "azurerm_public_ip" "lb_ip" {
  name                = format("%s-public-ip-lb", var.projeto)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge({ Name = format("%s-public-ip-lb", var.projeto) }, local.common_tags)
}

## Criar um Backend para o LoadBalancer
resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = format("%s-backend-pool", var.projeto)
  loadbalancer_id = azurerm_lb.lb.id
}

## Criar uma Regra de LoadBalancer com o Backend
resource "azurerm_lb_rule" "lbrule" {
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIP"
  probe_id                       = azurerm_lb_probe.lbp.id
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
}

## Criar um Probe para o LoadBalancer
resource "azurerm_lb_probe" "lbp" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

