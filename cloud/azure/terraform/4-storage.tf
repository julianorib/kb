## Criar um Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.projeto}stg${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = merge({ Name = format("%s-storage", var.projeto) }, local.common_tags)
}

## Criar um Compartilhamento para o VMSS
resource "azurerm_storage_share" "share" {
  name                 = format("%s-vmss-share", var.projeto)
  storage_account_id = azurerm_storage_account.storage.id
  quota                = 50
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
