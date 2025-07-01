## Criar o VMSS (Virtual Machine Scale Set)
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = format("%s-vmss", var.projeto)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B2s"
  instances           = 3
  zones               = ["1", "2", "3"]
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("id_rsa.pub")
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx

systemctl start nginx

echo $(hostname -s) >> /var/www/html/index.nginx-debian.html

apt-get install -y cifs-utils

mkdir -p /mnt/azfiles

echo "//${azurerm_storage_account.storage.name}.file.core.windows.net/${azurerm_storage_share.share.name} /mnt/azfiles cifs vers=3.0,username=${azurerm_storage_account.storage.name},password=${azurerm_storage_account.storage.primary_access_key},dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab

mount -a
EOF
  )
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface {
    name                      = format("%s-vmss-nic", var.projeto)
    primary                   = true
    network_security_group_id = azurerm_network_security_group.web.id

    ip_configuration {
      name                                   = "internal"
      subnet_id                              = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]

    }
  }

  upgrade_mode = "Manual"

  tags = merge({ Name = format("%s-vmss", var.projeto) }, local.common_tags)
}

## Criar as regras de Auto Scaling
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = format("%s-autoscaling-conf", var.projeto)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"
    capacity {
      minimum = "2"
      maximum = "5"
      default = "2"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}

## Criar um NSG para acesso WEB
resource "azurerm_network_security_group" "web" {
  name                = format("%s-nsg-web", var.projeto)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = merge({ Name = format("%s-nsg-web", var.projeto) }, local.common_tags)
}
