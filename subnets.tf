resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.10.1.0/27"]

}

resource "azurerm_subnet" "subnet-1" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.10.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

}
resource "azurerm_subnet" "subnet-2" {
  name                 = "private-subnet-2"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.10.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "netapp_delegation"
    service_delegation {
      name = "Microsoft.Netapp/volumes"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}

#################################

resource "azurerm_subnet" "subnet-3" {
  name                 = "public-subnet-3"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.10.4.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

}
resource "azurerm_subnet" "subnet-4" {
  name                 = "public-subnet-4"
  resource_group_name  = azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["10.10.5.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}



