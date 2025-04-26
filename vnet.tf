resource "azurerm_virtual_network" "vnet-1" {
  name                = "vnet-1"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name
  address_space       = ["10.10.0.0/16"]
}