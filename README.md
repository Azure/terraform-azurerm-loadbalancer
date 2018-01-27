# terraform-azurerm-loadbalancer #
[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer)

A terraform module to provide load balancers in Azure with the following
characteristics:

  - Ability to specify `public` or `private` loadbalancer using: `var.type`.  Default is public.
  - Specify subnet to use for the loadbalancer: `frontend_subnet_id` 
  - For `private` loadbalancer, specify the private ip address using
    `frontend_private_ip_address`
  - Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`

Usage
-----
Public loadbalancer example:

```hcl
variable "resource_group_name" {
  default = "my-terraform-lb"
}

variable "location" {
  default = "eastus"
}

module "mylb" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  prefix              = "terraform-test"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["80", "Tcp", "80"]
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}
```

Private loadbalancer example:

```hcl
module "mylb" {
  source                                 = "Azure/loadbalancer/azurerm"
  location                               = "westus"
  type                                   = "private"
  frontend_subnet_id                     = "${module.network.vnet_subnets[0]}"
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.0.1.6"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }

  "tags" {
    cost-center = "12345"
    source      = "terraform"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = "myapp"
  location            = "westus"
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
```

Test
-----
### Configurations
- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test module on local dev box:

### Native(Mac/Linux)

#### Prerequisites
- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.0)**](https://www.terraform.io/downloads.html)

#### Environment setup
We provide simple script to quickly set up module development environment:
```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```
#### Run test
Then simply run it in local shell:
```sh
$ bundle install
$ rake build
```

### Docker
We provide Dockerfile to build and run module development environment locally:

#### Prerequisites
- [Docker](https://www.docker.com/community-edition#/download)

#### Build the image
```sh
docker build -t azure-loadbalancer .
```
#### Run test
```sh
$ docker run -it azure-loadbalancer /bin/sh
$ rake build
```

Authors
=======

Originally created by [David Tesar](https://github.com/dtzar)

License
=======

[MIT](LICENSE)
