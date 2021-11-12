output "iothub_name" {
  value = var.create_iot_resources == true ? azurerm_iothub.elms[0].name : "your-iot-hub-name"
}

output "iothub_id" {
  value     = var.create_iot_resources == true ? azurerm_iothub.elms[0].id : "your-iot-hub-resource-id"
  sensitive = true
}
