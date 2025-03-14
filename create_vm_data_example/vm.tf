
data "azurerm_resource_group" "existing_reource_group" {
  name = "home_resource_group"
}


data "azurerm_subnet" "existing_private_subnet" {
  name                 = "private_subnet"
  virtual_network_name = "home_network"
  resource_group_name  = "home_resource_group"
}

resource "azurerm_public_ip" "vm_pub_ip" {
  name                = "vm_pub_ip"
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name
  location            = data.azurerm_resource_group.existing_reource_group.location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "az_nic" {
  name                = "az_nic"
  location            = data.azurerm_resource_group.existing_reource_group.location
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing_private_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pub_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "home_vm_1" {
  name                = "homevm"
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name
  location            = data.azurerm_resource_group.existing_reource_group.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.az_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("vm_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
