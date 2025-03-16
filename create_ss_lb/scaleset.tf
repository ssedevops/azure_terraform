locals {
  data_inputs = {
    heading_one = var.heading_one
  }

  location            = data.azurerm_resource_group.existing_reource_group.location
  resource_group_name = data.azurerm_resource_group.existing_reource_group.name
  subnet_id1          = data.azurerm_subnet.existing_private_subnet1.id
  subnet_id2          = data.azurerm_subnet.existing_private_subnet2.id
}


resource "azurerm_linux_virtual_machine_scale_set" "azure_ss" {
  name                = "scalesetvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "Standard_B2ats_v2" #"Standard_B2als_v2"   "Standard_B2ats_v2"
  instances           = 1
  admin_username      = "adminuser"
  priority            = "Spot"
  eviction_policy     = "Delete"
  # Adding User Data
  user_data = base64encode(templatefile("userdata.tftpl", local.data_inputs))

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

  network_interface {
    name    = "az_nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      subnet_id                              = local.subnet_id1
      primary                                = true
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.home_lb_backend_address_pool.id]

      #Its working, it assigns public ip to VM
      public_ip_address {
        name = "acceptanceTestPublicIp1"
      }

    }
  }
}
