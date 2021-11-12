resource "azurerm_iothub" "elms" {
  count                         = var.create_iot_resources == true ? 1 : 0
  name                          = "iot-${var.name_identifier}-${var.random_id}"
  resource_group_name           = var.rg_name
  location                      = var.location
  public_network_access_enabled = true
  

  sku {
    name     = var.tier
    capacity = var.units
  }

  fallback_route {
    source         = "DeviceMessages"
    endpoint_names = ["events"]
    enabled        = true
  }
}