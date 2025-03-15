data "azurerm_resource_group" "existing_reource_group" {
  name = "home_resource_group"
}


data "azurerm_subnet" "existing_private_subnet1" {
  name                 = "private_subnet1"
  virtual_network_name = "home_network"
  resource_group_name  = "home_resource_group"
}

data "azurerm_subnet" "existing_private_subnet2" {
  name                 = "private_subnet2"
  virtual_network_name = "home_network"
  resource_group_name  = "home_resource_group"
}

data "azurerm_network_security_group" "home_nsg" {
  name                = "home_nsg"
  resource_group_name = "home_resource_group"
}
