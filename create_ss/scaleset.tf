
data "azurerm_resource_group" "existing_reource_group" {
  name = "home_resource_group"
}


data "azurerm_subnet" "existing_private_subnet" {
  name                 = "private_subnet"
  virtual_network_name = "home_network"
  resource_group_name  = "home_resource_group"
}

# resource "azurerm_linux_virtual_machine_scale_set" "azure_ss" {
#   name                = "scalesetvm"
#   resource_group_name = data.azurerm_resource_group.existing_reource_group.name
#   location            = data.azurerm_resource_group.existing_reource_group.location
#   sku                 = "Standard_B1ls"
#   instances           = 1
#   admin_username      = "adminuser"

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("vm_key.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   network_interface {
#     name    = "az_nic"
#     primary = true

#     ip_configuration {
#       name      = "internal"
#       subnet_id = data.azurerm_subnet.existing_private_subnet.id
#       primary   = true
#     }
#   }
# }
