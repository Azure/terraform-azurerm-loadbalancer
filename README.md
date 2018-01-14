load balancer terraform module
===========

A terraform module to provide load balancers in Azure with the following
characteristics:

  - Ability to specify `public` or `private` loadbalancer using: `var.type`
  - Specify subnet to use for the loadbalancer :`frontend_subnet_id` 
  - For `private` loadbalancer, you can specify the private ip address using
    `frontend_private_ip_address`
  - Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`



Usage
-----

```hcl
module "mylb" {
  source                                  = "Azure/loadbalancer/azurerm"
  location                                = "westus"
  type                                    = "private"
  frontend_subnet_id                      = "${module.network.vnet_subnets[0]}"
  frontend_private_ip_address_allocation  = "Static"
  frontend_private_ip_address             = "10.0.1.6"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }
  "lb_port" {
    http = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }
  "tags" {
    cost-center = "12345"
    source     = "terraform"
  }
}

module "network" { 
    source              = "Azure/network/azurerm"
    resource_group_name = "myapp"
    location            = "westus"
    address_space       = "10.0.0.0/16"
    subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_names        = ["subnet1", "subnet2", "subnet3"]

    tags                = {
                            environment = "dev"
                            costcenter  = "it"
                          }
}
```

Authors
=======

[David Tesar](https://github.com/dtzar)

License
=======

[MIT](LICENSE)
