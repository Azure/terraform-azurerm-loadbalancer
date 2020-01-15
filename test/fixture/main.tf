resource "random_id" "rg_name" {
  byte_length = 8
}

module "mylb" {
  source              = "../../"
  resource_group_name = "${random_id.rg_name.hex}"
  location            = "${var.location}"
  prefix              = "${random_id.rg_name.hex}"

  remote_port ={
    ssh = ["Tcp", "22"]
  }

  lb_port ={
    http = ["80", "Tcp", "80"]
  }
}
