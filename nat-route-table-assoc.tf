resource "azurerm_subnet_route_table_association" "subnet-1" {
  subnet_id      = azurerm_subnet.subnet-1.id
  route_table_id = azurerm_route_table.NatGw1-route-table.id
}


###TEST-REMOVE
#resource "azurerm_subnet_route_table_association" "subnet-2" {
#  subnet_id      = azurerm_subnet.subnet-2.id
#  route_table_id = azurerm_route_table.NatGw1-route-table.id
#}