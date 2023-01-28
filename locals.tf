locals {
  lb_name   = var.name != "" ? var.name : format("%s-lb", var.prefix)
  pip_name  = var.pip_name != "" ? var.pip_name : format("%s-publicIP", var.prefix)
  subnet_id = try(coalesce(local.data_subnet_id, var.frontend_subnet_id), "")
}