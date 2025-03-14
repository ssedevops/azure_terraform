resource "azurerm_resource_group" "home_resource_group" {
  name     = var.home_resource_group
  location = "Central India"
}

resource "azurerm_virtual_network" "home_network" {
  name                = var.home_network
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.home_resource_group.location
  resource_group_name = azurerm_resource_group.home_resource_group.name
}

resource "azurerm_subnet" "private_subnet" {
  name                 = var.private_subnet
  resource_group_name  = azurerm_resource_group.home_resource_group.name
  virtual_network_name = azurerm_virtual_network.home_network.name
  address_prefixes     = ["10.0.2.0/24"]
}
