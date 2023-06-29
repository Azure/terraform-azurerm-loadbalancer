variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group where the load balancer resources will be imported."
}

variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "(Required) Defines how an IP address is assigned. Options are Static or Dynamic."
}

variable "disable_outbound_snat" {
  type        = bool
  default     = false
  description = "(Optional) Is snat enabled for this Load Balancer Rule? Default `false`."
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Changing this forces new resources to be created."
}

variable "frontend_ip_zones" {
  type        = list(string)
  default     = null
  description = "(Optional) A collection containing the availability zone to allocate the IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
}

variable "frontend_name" {
  type        = string
  default     = "myPublicIP"
  description = "(Required) Specifies the name of the frontend ip configuration."
}

variable "frontend_private_ip_address" {
  type        = string
  default     = ""
  description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
}

variable "frontend_private_ip_address_allocation" {
  type        = string
  default     = "Dynamic"
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
}

variable "frontend_private_ip_address_version" {
  type        = string
  default     = null
  description = "(Optional) The version of IP that the Private IP Address is. Possible values are `IPv4` or `IPv6`."
}

variable "frontend_subnet_id" {
  type        = string
  default     = ""
  description = "(Optional) Frontend subnet id to use when in private mode"
}

variable "frontend_subnet_name" {
  type        = string
  default     = ""
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
}

variable "frontend_vnet_name" {
  type        = string
  default     = ""
  description = "(Optional) Frontend virtual network name to use when in private mode. Conflict with `frontend_subnet_id`."
}

variable "lb_floating_ip_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Are the Floating IPs enabled for this Load Balancer Rule? A floating IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to `false`."
}

variable "lb_port" {
  type        = map(any)
  default     = {}
  description = "Protocols to be used for lb rules. Format as [frontend_port, protocol, backend_port]"
}

variable "lb_probe" {
  type        = map(any)
  default     = {}
  description = "(Optional) Protocols to be used for lb health probes. Format as [protocol, port, request_path]"
}

variable "lb_probe_interval" {
  type        = number
  default     = 5
  description = "Interval in seconds the load balancer health probe rule does a check"
}

variable "lb_probe_unhealthy_threshold" {
  type        = number
  default     = 2
  description = "Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
}

variable "lb_sku" {
  type        = string
  default     = "Basic"
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
}

variable "lb_sku_tier" {
  type        = string
  default     = "Regional"
  description = "(Optional) The SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = ""
  description = "(Optional) The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "name" {
  type        = string
  default     = ""
  description = "(Optional) Name of the load balancer. If it is set, the 'prefix' variable will be ignored."
}

variable "pip_ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = "(Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`."
}

variable "pip_ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of DDoS protection plan associated with the public IP. `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`."
}

variable "pip_domain_name_label" {
  type        = string
  default     = null
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN.  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "pip_idle_timeout_in_minutes" {
  type        = number
  default     = 4
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to `4`."
}

variable "pip_ip_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created. IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set."
}

variable "pip_ip_version" {
  type        = string
  default     = "IPv4"
  description = "(Optional) The IP Version to use, `IPv6` or `IPv4`. Defaults to `IPv4`. Changing this forces a new resource to be created. Only `static` IP address allocation is supported for `IPv6`."
}

variable "pip_name" {
  type        = string
  default     = ""
  description = "(Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored."
}

variable "pip_public_ip_prefix_id" {
  type        = string
  default     = null
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created."
}

variable "pip_reverse_fqdn" {
  type        = string
  default     = null
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
}

variable "pip_sku" {
  type        = string
  default     = "Basic"
  description = "(Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard."
}

variable "pip_sku_tier" {
  type        = string
  default     = "Regional"
  description = "(Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created."
}

variable "pip_zones" {
  type        = list(string)
  default     = null
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
}

variable "prefix" {
  type        = string
  default     = "azure_lb"
  description = "(Required) Default prefix to use with your resource names."
}

variable "remote_port" {
  type        = map(any)
  default     = {}
  description = "Protocols to be used for remote vm access. [protocol, backend_port].  Frontend port will be automatically generated starting at 50000 and in the output."
}

variable "tags" {
  type = map(string)
  default = {
    source = "terraform"
  }
  description = "(Optional) A mapping of tags to assign to the resource."
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_prefix" {
  type        = string
  default     = "avm_"
  description = "Default prefix for generated tracing tags"
  nullable    = false
}

variable "type" {
  type        = string
  default     = "public"
  description = "(Optional) Defined if the loadbalancer is private or public"
}
