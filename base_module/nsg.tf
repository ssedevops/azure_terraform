resource "azurerm_network_security_group" "home_nsg" {
  name                = "home_nsg"
  location            = azurerm_resource_group.home_resource_group.location
  resource_group_name = azurerm_resource_group.home_resource_group.name
}


# Create NSG Rule - Allow SSH (Port 22)
resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow" #"Deny" #
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.home_resource_group.name
  network_security_group_name = azurerm_network_security_group.home_nsg.name
}

# Create NSG Rule - Allow HTTP (Port 80)
resource "azurerm_network_security_rule" "http" {
  name                        = "allow-http"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.home_resource_group.name
  network_security_group_name = azurerm_network_security_group.home_nsg.name
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.private_subnet1.id
  network_security_group_id = azurerm_network_security_group.home_nsg.id
}
