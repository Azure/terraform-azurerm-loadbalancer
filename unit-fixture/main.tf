locals {
  data_subnet_id = try(data.null_data_source.snet[0].id, "")
}

data "null_data_source" "snet" {
  count = var.frontend_subnet_name != "" ? 1 : 0

  inputs = {
    name                 = var.frontend_subnet_name
    virtual_network_name = var.frontend_vnet_name
  }
}