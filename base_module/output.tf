
output "home_resource_group_name" {
  value = azurerm_resource_group.home_resource_group.name
}

output "home_resource_group_location" {
  value = azurerm_resource_group.home_resource_group.location
}

output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}
