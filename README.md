load balancer terraform module
===========

A terraform module to provide load balancers in Azure.


Usage
-----

```hcl
module "mylb" {
  source   = "Azure/loadbalancer/azurerm"
  location = "North Central US"
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
```

Authors
=======

[David Tesar](https://github.com/dtzar)

License
=======

[MIT](LICENSE)
