resource "azurerm_private_endpoint" "netapp" {
  name                = "netapp-private-endpoint"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name
  subnet_id           = azurerm_subnet.subnet-2.id

  private_service_connection {
    name                           = "netapp-connection"
    private_connection_resource_id = azurerm_netapp_account.netapp1.id
    is_manual_connection           = false
    subresource_names              = ["volume"]
  }
}