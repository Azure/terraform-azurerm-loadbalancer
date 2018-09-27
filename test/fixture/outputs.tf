output "public_ip" {
  value = "${module.mylb.azurerm_public_ip_address}"
}
