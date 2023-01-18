locals {
  lb_name         = var.name != "" ? var.name : format("%s-lb", var.prefix)
  pip_name        = var.pip_name != "" ? var.pip_name : format("%s-publicIP", var.prefix)
  vnet_id_by_name = length(data.azurerm_subnet.snet) == 1 ? element(data.azurerm_subnet.snet[*].id, 0) : ""
}