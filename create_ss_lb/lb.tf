resource "azurerm_public_ip" "lb_pub_ip" {
  name                = "lb_pub_ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Load Balancer
resource "azurerm_lb" "home_lb" {
  name                = "home-lb"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "home-lb-frontend"
    public_ip_address_id = azurerm_public_ip.lb_pub_ip.id
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "home_lb_backend_address_pool" {
  name            = "home_lb_backend_address_pool"
  loadbalancer_id = azurerm_lb.home_lb.id
}

# Health Probe
resource "azurerm_lb_probe" "home_lb_probe" {
  loadbalancer_id = azurerm_lb.home_lb.id
  name            = "http-probe"
  protocol        = "Tcp"
  port            = 80
}

# Load Balancer Rule (for HTTP traffic)
resource "azurerm_lb_rule" "home_http_lb_rule" {
  loadbalancer_id                = azurerm_lb.home_lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "home-lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.home_lb_backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.home_lb_probe.id
}
