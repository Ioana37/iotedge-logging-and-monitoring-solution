terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.84.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "elms" {
  byte_length = 2
}

resource "azurerm_resource_group" "elms" {
  name     = "rg-elms"
  location = var.location
}

module "iothub" {
  source                    = "../../modules/iothub"
  rg_name                   = azurerm_resource_group.elms.name
  location                  = var.location
  random_id                 = lower(random_id.elms.hex)
  name_identifier           = var.name_identifier
  tier                      = var.tier
  units                     = var.units
  create_iot_resources      = var.create_iot_resources
}

module "iotedgedevice" {
  source                    = "../../modules/iotedgedevice"
  iothub_name               = module.iothub.iothub_name
  edge_device_name          = "edge-device-01"
  create_iot_resources      = var.create_iot_resources
}

module "iotedgevm" {
  source                     = "../../modules/iotedgevm"
  rg_name                    = azurerm_resource_group.elms.name
  location                   = var.location
  random_id                  = lower(random_id.elms.hex)
  name_identifier            = var.name_identifier
  iot_hub_name               = module.iothub.iothub_name
  iot_edge_connection_string = module.iotedgedevice.edge_device_connection_string
  vm_user_name               = "edge-elms"
  create_iot_resources       = var.create_iot_resources
}

module "iotelms" {
  source                       = "../../modules/iotelms"
  rg_name                      = var.rg_name
  location                     = var.location
  name_identifier              = var.name_identifier
  random_id                    = lower(random_id.elms.hex)
  iothub_id                    = module.iothub.iothub_id
  iothub_name                  = module.iothub.iothub_name
  send_metrics_device_to_cloud = var.send_metrics_device_to_cloud
  create_iot_resources         = var.create_iot_resources
}