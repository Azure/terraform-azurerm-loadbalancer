resource "random_id" "rg_name" {
  byte_length = 8
}

module "mylb" {
  source              = "../../"
  resource_group_name = "${random_id.rg_name.hex}"
  location            = "${var.location}"
  prefix              = "${random_id.rg_name.hex}"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["80", "Tcp", "80"]
    http-2 = ["80", "Https", "443","/","TCP"]
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  location            = "${var.location}"
  resource_group_name = "${random_id.rg_name.hex}"
}
