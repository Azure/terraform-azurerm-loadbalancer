# terraform-azurerm-loadbalancer #
[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-loadbalancer)

Create a basic load balancer in Azure
===========

This Terraform module deploys a load balancer in Azure.

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
