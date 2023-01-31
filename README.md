# terraform-azurerm-loadbalancer

A terraform module to provide load balancers in Azure with the following
characteristics:

- Ability to specify `public` or `private` loadbalancer using: `var.type`.  Default is public.
- Specify subnet to use for the loadbalancer: `frontend_subnet_id`
- For `private` loadbalancer, specify the private ip address using`frontend_private_ip_address`
- Specify the type of the private ip address with `frontend_private_ip_address_allocation`, Dynamic or Static , default is `Dynamic`

## Notice on Upgrade to V4.x

We've added a CI pipeline for this module to speed up our code review and to enforce a high code quality standard, if you want to contribute by submitting a pull request, please read [Pre-Commit & Pr-Check & Test](#Pre-Commit--Pr-Check--Test) section, or your pull request might be rejected by CI pipeline.

A pull request will be reviewed when it has passed Pre Pull Request Check in the pipeline, and will be merged when it has passed the acceptance tests. Once the ci Pipeline failed, please read the pipeline's output, thanks for your cooperation.


## Usage in Terraform 1.2.0

Please view folders in `examples`.

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

## Pre-Commit & Pr-Check & Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirement(We strongly recommend you run the following command before you commit):

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

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
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet)                                | data source |

## Inputs

| Name                                                                                                                                                         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Type           | Default                                      | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|----------------------------------------------|:--------:|
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method)                                                                      | (Required) Defines how an IP address is assigned. Options are Static or Dynamic.                                                                                                                                                                                                                                                                                                                                                                                                                                     | `string`       | `"Static"`                                   |    no    |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone)                                                                                              | (Optional) Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Changing this forces new resources to be created.                                                                                                                                                                                                                                                                                                                                                    | `string`       | `null`                                       |    no    |
| <a name="input_frontend_name"></a> [frontend\_name](#input\_frontend\_name)                                                                                  | (Required) Specifies the name of the frontend ip configuration.                                                                                                                                                                                                                                                                                                                                                                                                                                                      | `string`       | `"myPublicIP"`                               |    no    |
| <a name="input_frontend_private_ip_address"></a> [frontend\_private\_ip\_address](#input\_frontend\_private\_ip\_address)                                    | (Optional) Private ip address to assign to frontend. Use it with type = private                                                                                                                                                                                                                                                                                                                                                                                                                                      | `string`       | `""`                                         |    no    |
| <a name="input_frontend_private_ip_address_allocation"></a> [frontend\_private\_ip\_address\_allocation](#input\_frontend\_private\_ip\_address\_allocation) | (Optional) Frontend ip allocation type (Static or Dynamic)                                                                                                                                                                                                                                                                                                                                                                                                                                                           | `string`       | `"Dynamic"`                                  |    no    |
| <a name="input_frontend_subnet_id"></a> [frontend\_subnet\_id](#input\_frontend\_subnet\_id)                                                                 | (Optional) Frontend subnet id to use when in private mode                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `string`       | `""`                                         |    no    |
| <a name="input_frontend_subnet_name"></a> [frontend\_subnet\_name](#input\_frontend\_subnet\_name)                                                           | (Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`.                                                                                                                                                                                                                                                                                                                                                                                                            | `string`       | `""`                                         |    no    |
| <a name="input_frontend_vnet_name"></a> [frontend\_vnet\_name](#input\_frontend\_vnet\_name)                                                                 | (Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`.                                                                                                                                                                                                                                                                                                                                                                                                            | `string`       | `""`                                         |    no    |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port)                                                                                                    | Protocols to be used for lb rules. Format as [frontend\_port, protocol, backend\_port]                                                                                                                                                                                                                                                                                                                                                                                                                               | `map(any)`     | `{}`                                         |    no    |
| <a name="input_lb_probe"></a> [lb\_probe](#input\_lb\_probe)                                                                                                 | (Optional) Protocols to be used for lb health probes. Format as [protocol, port, request\_path]                                                                                                                                                                                                                                                                                                                                                                                                                      | `map(any)`     | `{}`                                         |    no    |
| <a name="input_lb_probe_interval"></a> [lb\_probe\_interval](#input\_lb\_probe\_interval)                                                                    | Interval in seconds the load balancer health probe rule does a check                                                                                                                                                                                                                                                                                                                                                                                                                                                 | `number`       | `5`                                          |    no    |
| <a name="input_lb_probe_unhealthy_threshold"></a> [lb\_probe\_unhealthy\_threshold](#input\_lb\_probe\_unhealthy\_threshold)                                 | Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy.                                                                                                                                                                                                                                                                                                                                                                                                | `number`       | `2`                                          |    no    |
| <a name="input_lb_sku"></a> [lb\_sku](#input\_lb\_sku)                                                                                                       | (Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard.                                                                                                                                                                                                                                                                                                                                                                                                                               | `string`       | `"Basic"`                                    |    no    |
| <a name="input_lb_sku_tier"></a> [lb\_sku\_tier](#input\_lb\_sku\_tier)                                                                                      | (Optional) The SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Changing this forces a new resource to be created.                                                                                                                                                                                                                                                                                                                                               | `string`       | `"Regional"`                                 |    no    |
| <a name="input_location"></a> [location](#input\_location)                                                                                                   | (Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions                                                                                                                                                                                                                                                                                                                                                            | `string`       | `""`                                         |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                                               | (Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored.                                                                                                                                                                                                                                                                                                                                                                                                                           | `string`       | `""`                                         |    no    |
| <a name="input_pip_ddos_protection_mode"></a> [pip\_ddos\_protection\_mode](#input\_pip\_ddos\_protection\_mode)                                             | (Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`.                                                                                                                                                                                                                                                                                                                                               | `string`       | `"VirtualNetworkInherited"`                  |    no    |
| <a name="input_pip_ddos_protection_plan_id"></a> [pip\_ddos\_protection\_plan\_id](#input\_pip\_ddos\_protection\_plan\_id)                                  | (Optional) The ID of DDoS protection plan associated with the public IP. `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`.                                                                                                                                                                                                                                                                                                                                                         | `string`       | `null`                                       |    no    |
| <a name="input_pip_domain_name_label"></a> [pip\_domain\_name\_label](#input\_pip\_domain\_name\_label)                                                      | (Optional) Label for the Domain Name. Will be used to make up the FQDN.  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.                                                                                                                                                                                                                                                                                                                        | `string`       | `null`                                       |    no    |
| <a name="input_pip_idle_timeout_in_minutes"></a> [pip\_idle\_timeout\_in\_minutes](#input\_pip\_idle\_timeout\_in\_minutes)                                  | (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to `4`.                                                                                                                                                                                                                                                                                                                                                                                        | `number`       | `4`                                          |    no    |
| <a name="input_pip_ip_tags"></a> [pip\_ip\_tags](#input\_pip\_ip\_tags)                                                                                      | (Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created. IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set.                                                                                                                                                                                                                                                                                                                    | `map(string)`  | `null`                                       |    no    |
| <a name="input_pip_ip_version"></a> [pip\_ip\_version](#input\_pip\_ip\_version)                                                                             | (Optional) The IP Version to use, `IPv6` or `IPv4`. Defaults to `IPv4`. Changing this forces a new resource to be created. Only `static` IP address allocation is supported for `IPv6`.                                                                                                                                                                                                                                                                                                                              | `string`       | `"IPv4"`                                     |    no    |
| <a name="input_pip_name"></a> [pip\_name](#input\_pip\_name)                                                                                                 | (Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored.                                                                                                                                                                                                                                                                                                                                                                                                                                   | `string`       | `""`                                         |    no    |
| <a name="input_pip_public_ip_prefix_id"></a> [pip\_public\_ip\_prefix\_id](#input\_pip\_public\_ip\_prefix\_id)                                              | (Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created.                                                                                                                                                                                                                                                                                                                                                     | `string`       | `null`                                       |    no    |
| <a name="input_pip_reverse_fqdn"></a> [pip\_reverse\_fqdn](#input\_pip\_reverse\_fqdn)                                                                       | (Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.                                                                                                                                                                                                                                                                                     | `string`       | `null`                                       |    no    |
| <a name="input_pip_sku"></a> [pip\_sku](#input\_pip\_sku)                                                                                                    | (Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard.                                                                                                                                                                                                                                                                                                                                                                                                                                   | `string`       | `"Basic"`                                    |    no    |
| <a name="input_pip_sku_tier"></a> [pip\_sku\_tier](#input\_pip\_sku\_tier)                                                                                   | (Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created.                                                                                                                                                                                                                                                                                                                               | `string`       | `"Regional"`                                 |    no    |
| <a name="input_pip_zones"></a> [pip\_zones](#input\_pip\_zones)                                                                                              | (Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default. | `list(string)` | `null`                                       |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                                         | (Required) Default prefix to use with your resource names.                                                                                                                                                                                                                                                                                                                                                                                                                                                           | `string`       | `"azure_lb"`                                 |    no    |
| <a name="input_remote_port"></a> [remote\_port](#input\_remote\_port)                                                                                        | Protocols to be used for remote vm access. [protocol, backend\_port].  Frontend port will be automatically generated starting at 50000 and in the output.                                                                                                                                                                                                                                                                                                                                                            | `map(any)`     | `{}`                                         |    no    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)                                                              | (Required) The name of the resource group where the load balancer resources will be imported.                                                                                                                                                                                                                                                                                                                                                                                                                        | `string`       | n/a                                          |   yes    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                               | (Optional) A mapping of tags to assign to the resource.                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `map(string)`  | <pre>{<br>  "source": "terraform"<br>}</pre> |    no    |
| <a name="input_type"></a> [type](#input\_type)                                                                                                               | (Optional) Defined if the loadbalancer is private or public                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `string`       | `"public"`                                   |    no    |

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
