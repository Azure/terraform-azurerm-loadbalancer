locals {
  lb_name  = var.name != "" ? var.name : format("%s-lb", var.prefix)
  pip_name = var.pip_name != "" ? var.pip_name : format("%s-publicIP", var.prefix)
}