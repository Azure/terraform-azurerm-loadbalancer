variable "resource_group_name" {
  description = "(Required) The name of the resource group where the load balancer resources will be imported."
  type        = string
}

variable "allocation_method" {
  description = "(Required) Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Static"
}

variable "disable_outbound_snat" {
  description = "(Optional) Is snat enabled for this Load Balancer Rule? Default `false`."
  type        = bool
  default     = false
}

variable "edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Changing this forces new resources to be created."
  default     = null
}

variable "frontend_name" {
  description = "(Required) Specifies the name of the frontend ip configuration."
  type        = string
  default     = "myPublicIP"
}

variable "frontend_private_ip_address" {
  description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
  type        = string
  default     = ""
}

variable "frontend_private_ip_address_allocation" {
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
  type        = string
  default     = "Dynamic"
}

variable "frontend_subnet_id" {
  description = "(Optional) Frontend subnet id to use when in private mode"
  type        = string
  default     = ""
}

variable "frontend_subnet_name" {
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
  type        = string
  default     = ""
}

variable "frontend_vnet_name" {
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
  type        = string
  default     = ""
}

variable "lb_port" {
  description = "Protocols to be used for lb rules. Format as [frontend_port, protocol, backend_port]"
  type        = map(any)
  default     = {}
}

variable "lb_probe" {
  description = "(Optional) Protocols to be used for lb health probes. Format as [protocol, port, request_path]"
  type        = map(any)
  default     = {}
}

variable "lb_probe_interval" {
  description = "Interval in seconds the load balancer health probe rule does a check"
  type        = number
  default     = 5
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  type        = number
  default     = 2
}

variable "lb_sku" {
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "lb_sku_tier" {
  description = "(Optional) The SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Changing this forces a new resource to be created."
  type        = string
  default     = "Regional"
}

variable "location" {
  description = "(Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
  default     = ""
}

variable "name" {
  description = "(Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored."
  type        = string
  default     = ""
}

variable "pip_ddos_protection_mode" {
  type        = string
  description = "(Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`."
  default     = "VirtualNetworkInherited"
}

variable "pip_ddos_protection_plan_id" {
  type        = string
  description = "(Optional) The ID of DDoS protection plan associated with the public IP. `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`."
  default     = null
}

variable "pip_domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN.  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}

variable "pip_idle_timeout_in_minutes" {
  type        = number
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to `4`."
  default     = 4
}

variable "pip_ip_tags" {
  type        = map(string)
  description = "(Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created. IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set."
  default     = null
}

variable "pip_ip_version" {
  type        = string
  description = "(Optional) The IP Version to use, `IPv6` or `IPv4`. Defaults to `IPv4`. Changing this forces a new resource to be created. Only `static` IP address allocation is supported for `IPv6`."
  default     = "IPv4"
}

variable "pip_name" {
  description = "(Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored."
  type        = string
  default     = ""
}

variable "pip_public_ip_prefix_id" {
  type        = string
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created."
  default     = null
}

variable "pip_reverse_fqdn" {
  type        = string
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
  default     = null
}

variable "pip_sku" {
  description = "(Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "pip_sku_tier" {
  type        = string
  description = "(Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created."
  default     = "Regional"
}

variable "pip_zones" {
  type        = list(string)
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
  default     = null
}

variable "prefix" {
  description = "(Required) Default prefix to use with your resource names."
  type        = string
  default     = "azure_lb"
}

variable "remote_port" {
  description = "Protocols to be used for remote vm access. [protocol, backend_port].  Frontend port will be automatically generated starting at 50000 and in the output."
  type        = map(any)
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default = {
    source = "terraform"
  }
}

variable "type" {
  description = "(Optional) Defined if the loadbalancer is private or public"
  type        = string
  default     = "public"
}