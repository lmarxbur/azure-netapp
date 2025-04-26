resource "azurerm_route_table" "NatGw1-route-table" {
  name                = "natGW-1-route-table"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name
  #bgp_route_propagation_enabled = true

  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}
