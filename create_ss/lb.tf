resource "azurerm_public_ip" "vm_pub_ip" {
  name                = "vm_pub_ip"
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name
  location            = data.azurerm_resource_group.existing_reource_group.location
  allocation_method   = "Dynamic"
}


resource "azurerm_lb" "az_lb" {
  name                = "TestLoadBalancer"
  location            = data.azurerm_resource_group.existing_reource_group.location
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vm_pub_ip.id
  }
}
