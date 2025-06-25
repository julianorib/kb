resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "vmss-web"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B2s"
  instances           = 2
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  disable_password_authentication = false

  custom_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y cifs-utils

mkdir -p /mnt/azfiles

echo "//${azurerm_storage_account.storage.name}.file.core.windows.net/${azurerm_storage_share.share.name} /mnt/azfiles cifs vers=3.0,username=${azurerm_storage_account.storage.name},password=${azurerm_storage_account.storage.primary_access_key},dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab

mount -a
EOF
  )

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
    }
  }

  upgrade_mode = "Manual"
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-setting"
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

