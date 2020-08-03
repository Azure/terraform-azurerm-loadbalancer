# terraform-azurerm-loadbalancer

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer)

A terraform module to provide load balancers in Azure with the following
characteristics:

- Ability to specify `public` or `private` loadbalancer using: `var.type`.  Default is public.
- Specify subnet to use for the loadbalancer: `frontend_subnet_id`
- For `private` loadbalancer, specify the private ip address using`frontend_private_ip_address`
- Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`

## Usage

Public loadbalancer example:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-lb"
  location = "West Europe"
}

module "mylb" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  prefix              = "terraform-test"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["80", "Tcp", "80"]
  }
}

```

Private loadbalancer example:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-lb"
  location = "West Europe"
}

module "mylb" {
  source                                 = "Azure/loadbalancer/azurerm"
  resource_group_name                    = azurerm_resource_group.example.name
  type                                   = "private"
  frontend_subnet_id                     = module.network.vnet_subnets[0]
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.0.1.6"
  lb_sku                                 = "Standard"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http   = ["80", "Tcp", "80"]
    https  = ["443", "Tcp", "443"]
    https2 = ["1443", "Tcp", "1443", "/", "Https"]
  }

  tags = {
    cost-center = "12345"
    source      = "terraform"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native(Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install
$ rake build
$ rake e2e
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `microsoft/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-loadbalancer .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-loadbalancer /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-loadbalancer /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-loadbalancer /bin/bash -c "bundle install && rake full"
```

## Authors

Originally created by [David Tesar](https://github.com/dtzar)

## License

[MIT](LICENSE)
