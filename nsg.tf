resource "azurerm_network_security_group" "nsg-1" {
  name                = "nsg-1"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name
}

resource "azurerm_network_security_rule" "nsg-1" {
  name                        = "all-out"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-1.name
  network_security_group_name = azurerm_network_security_group.nsg-1.name
}

resource "azurerm_network_security_rule" "nsg-2" {
  name                        = "all-in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.RG-1.name
  network_security_group_name = azurerm_network_security_group.nsg-1.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-1-1" {
  subnet_id                 = azurerm_subnet.subnet-1.id
  network_security_group_id = azurerm_network_security_group.nsg-1.id
}

resource "azurerm_subnet_network_security_group_association" "nsg-1-2" {
  subnet_id                 = azurerm_subnet.subnet-2.id
  network_security_group_id = azurerm_network_security_group.nsg-1.id
}