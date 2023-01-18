resource "random_id" "rg_name" {
  byte_length = 8
}

resource "azurerm_resource_group" "test" {
  location = var.location
  name     = "example-lb-${random_id.rg_name.hex}"
}

module "mylb" {
  source                                 = "../.."
  resource_group_name                    = azurerm_resource_group.test.name
  type                                   = "private"
  frontend_vnet_name                     = "accvnet1"
  frontend_subnet_name                   = "subnet1"
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.0.1.6"
  lb_sku                                 = "Standard"
  location                               = var.location
  pip_sku                                = "Standard"
  name                                   = "lb-aztest"
  pip_name                               = "pip-aztest"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }

  lb_probe = {
    http  = ["Tcp", "80", ""]
    http2 = ["Http", "1443", "/"]
  }

  tags = {
    cost-center = "12345"
    source      = "terraform"
  }

  depends_on = [module.network]
}

module "network" {
  source                  = "Azure/network/azurerm"
  version                 = "4.2.0"
  resource_group_name     = azurerm_resource_group.test.name
  address_space           = "10.0.0.0/16"
  resource_group_location = var.location
  subnet_prefixes         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vnet_name               = "accvnet1"
  subnet_names            = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.test]
}
