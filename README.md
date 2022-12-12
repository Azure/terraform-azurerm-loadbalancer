# terraform-azurerm-loadbalancer

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer)

A terraform module to provide load balancers in Azure with the following
characteristics:

- Ability to specify `public` or `private` loadbalancer using: `var.type`.  Default is public.
- Specify subnet to use for the loadbalancer: `frontend_subnet_id`
- For `private` loadbalancer, specify the private ip address using`frontend_private_ip_address`
- Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`

## Usage in Terraform 0.13

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
  name                = "lb-terraform-test"
  pip_name            = "pip-terraform-test"

  remote_port = {
    ssh = ["Tcp", "22"]
  }

  lb_port = {
    http = ["80", "Tcp", "80"]
  }

  lb_probe = {
    http = ["Tcp", "80", ""]
  }

  depends_on = [azurerm_resource_group.example]
}

```

## Usage in Terraform 0.12

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

  lb_probe = {
    http = ["Tcp", "80", ""]
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
  pip_sku                                = "Standard" #`pip_sku` must match `lb_sku` 

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2   |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.0.0 |

## Providers

| Name                                                          | Version  |
|---------------------------------------------------------------|----------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type        |
|-------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [azurerm_lb.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb)                                           | resource    |
| [azurerm_lb_backend_address_pool.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource    |
| [azurerm_lb_nat_rule.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule)                         | resource    |
| [azurerm_lb_probe.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe)                               | resource    |
| [azurerm_lb_rule.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule)                                 | resource    |
| [azurerm_public_ip.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)                             | resource    |
| [azurerm_resource_group.azlb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)                | data source |

## Inputs

| Name                                                                                                                                                         | Description                                                                                                                                               | Type          | Default                                      | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------------------------------------------|:--------:|
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method)                                                                      | (Required) Defines how an IP address is assigned. Options are Static or Dynamic.                                                                          | `string`      | `"Static"`                                   |    no    |
| <a name="input_frontend_name"></a> [frontend\_name](#input\_frontend\_name)                                                                                  | (Required) Specifies the name of the frontend ip configuration.                                                                                           | `string`      | `"myPublicIP"`                               |    no    |
| <a name="input_frontend_private_ip_address"></a> [frontend\_private\_ip\_address](#input\_frontend\_private\_ip\_address)                                    | (Optional) Private ip address to assign to frontend. Use it with type = private                                                                           | `string`      | `""`                                         |    no    |
| <a name="input_frontend_private_ip_address_allocation"></a> [frontend\_private\_ip\_address\_allocation](#input\_frontend\_private\_ip\_address\_allocation) | (Optional) Frontend ip allocation type (Static or Dynamic)                                                                                                | `string`      | `"Dynamic"`                                  |    no    |
| <a name="input_frontend_subnet_id"></a> [frontend\_subnet\_id](#input\_frontend\_subnet\_id)                                                                 | (Optional) Frontend subnet id to use when in private mode                                                                                                 | `string`      | `""`                                         |    no    |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port)                                                                                                    | Protocols to be used for lb rules. Format as [frontend\_port, protocol, backend\_port]                                                                    | `map(any)`    | `{}`                                         |    no    |
| <a name="input_lb_probe"></a> [lb\_probe](#input\_lb\_probe)                                                                                                 | (Optional) Protocols to be used for lb health probes. Format as [protocol, port, request\_path]                                                           | `map(any)`    | `{}`                                         |    no    |
| <a name="input_lb_probe_interval"></a> [lb\_probe\_interval](#input\_lb\_probe\_interval)                                                                    | Interval in seconds the load balancer health probe rule does a check                                                                                      | `number`      | `5`                                          |    no    |
| <a name="input_lb_probe_unhealthy_threshold"></a> [lb\_probe\_unhealthy\_threshold](#input\_lb\_probe\_unhealthy\_threshold)                                 | Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy.                                     | `number`      | `2`                                          |    no    |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku)                                                                                                       | (Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard.                                                                    | `string`      | `"Basic"`                                    |    no    |
| <a name="input_location"></a> [location](#input\_location)                                                                                                   | (Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string`      | `""`                                         |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                                               | (Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored.                                                                | `string`      | `""`                                         |    no    |
| <a name="input_pip_name"></a> [pip\_name](#input\_pip\_name)                                                                                                 | (Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored.                                                                        | `string`      | `""`                                         |    no    |
| <a name="input_pip_sku"></a> [pip\_sku](#input\_pip\_sku)                                                                                                    | (Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard.                                                                        | `string`      | `"Basic"`                                    |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                                         | (Required) Default prefix to use with your resource names.                                                                                                | `string`      | `"azure_lb"`                                 |    no    |
| <a name="input_remote_port"></a> [remote\_port](#input\_remote\_port)                                                                                        | Protocols to be used for remote vm access. [protocol, backend\_port].  Frontend port will be automatically generated starting at 50000 and in the output. | `map(any)`    | `{}`                                         |    no    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)                                                              | (Required) The name of the resource group where the load balancer resources will be imported.                                                             | `string`      | n/a                                          |   yes    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                               | (Optional) A mapping of tags to assign to the resource.                                                                                                   | `map(string)` | <pre>{<br>  "source": "terraform"<br>}</pre> |    no    |
| <a name="input_type"></a> [type](#input\_type)                                                                                                               | (Optional) Defined if the loadbalancer is private or public                                                                                               | `string`      | `"public"`                                   |    no    |

## Outputs

| Name                                                                                                                                                     | Description                                                  |
|----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| <a name="output_azurerm_lb_backend_address_pool_id"></a> [azurerm\_lb\_backend\_address\_pool\_id](#output\_azurerm\_lb\_backend\_address\_pool\_id)     | the id for the azurerm\_lb\_backend\_address\_pool resource  |
| <a name="output_azurerm_lb_frontend_ip_configuration"></a> [azurerm\_lb\_frontend\_ip\_configuration](#output\_azurerm\_lb\_frontend\_ip\_configuration) | the frontend\_ip\_configuration for the azurerm\_lb resource |
| <a name="output_azurerm_lb_id"></a> [azurerm\_lb\_id](#output\_azurerm\_lb\_id)                                                                          | the id for the azurerm\_lb resource                          |
| <a name="output_azurerm_lb_nat_rule_ids"></a> [azurerm\_lb\_nat\_rule\_ids](#output\_azurerm\_lb\_nat\_rule\_ids)                                        | the ids for the azurerm\_lb\_nat\_rule resources             |
| <a name="output_azurerm_lb_probe_ids"></a> [azurerm\_lb\_probe\_ids](#output\_azurerm\_lb\_probe\_ids)                                                   | the ids for the azurerm\_lb\_probe resources                 |
| <a name="output_azurerm_public_ip_address"></a> [azurerm\_public\_ip\_address](#output\_azurerm\_public\_ip\_address)                                    | the ip address for the azurerm\_lb\_public\_ip resource      |
| <a name="output_azurerm_public_ip_id"></a> [azurerm\_public\_ip\_id](#output\_azurerm\_public\_ip\_id)                                                   | the id for the azurerm\_lb\_public\_ip resource              |
| <a name="output_azurerm_resource_group_name"></a> [azurerm\_resource\_group\_name](#output\_azurerm\_resource\_group\_name)                              | name of the resource group provisioned                       |
| <a name="output_azurerm_resource_group_tags"></a> [azurerm\_resource\_group\_tags](#output\_azurerm\_resource\_group\_tags)                              | the tags provided for the resource group                     |
<!-- END_TF_DOCS -->
