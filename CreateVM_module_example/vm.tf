
module "base_component" {
  source              = "./modules/base_module"
  home_resource_group = "home_resource_group"
  home_network        = "home_network"
  private_subnet      = "private_subnet"
}


resource "azurerm_public_ip" "vm_pub_ip" {
  name                = "vm_pub_ip"
  resource_group_name = module.base_component.home_resource_group_name
  location            = module.base_component.home_resource_group_location
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "az_nic" {
  name                = "az_nic"
  location            = module.base_component.home_resource_group_location
  resource_group_name = module.base_component.home_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.base_component.private_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pub_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "home_vm_1" {
  name                = "homevm"
  resource_group_name = module.base_component.home_resource_group_name
  location            = module.base_component.home_resource_group_location
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
