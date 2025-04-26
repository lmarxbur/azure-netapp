resource "azurerm_resource_group" "dummy" {
  count    = var.create_resource ? 1 : 0
  name     = "dummy-resource-group"
  location = "East US"
}
