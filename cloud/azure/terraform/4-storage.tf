
resource "azurerm_storage_account" "storage" {
  name                     = "webfilesstorage${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "share" {
  name                 = "webfiles"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}
