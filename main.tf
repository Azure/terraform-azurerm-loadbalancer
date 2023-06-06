# Azure load balancer module
data "azurerm_resource_group" "azlb" {
  name = var.resource_group_name
}

data "azurerm_subnet" "snet" {
  count = (var.frontend_subnet_name != null && var.frontend_subnet_name != "") ? 1 : 0

  name                 = var.frontend_subnet_name
  resource_group_name  = data.azurerm_resource_group.azlb.name
  virtual_network_name = var.frontend_vnet_name
}

locals {
  data_subnet_id = try(data.azurerm_subnet.snet[0].id, "")
}

resource "azurerm_public_ip" "azlb" {
  count = var.type == "public" ? 1 : 0

  allocation_method       = var.allocation_method
  location                = coalesce(var.location, data.azurerm_resource_group.azlb.location)
  name                    = local.pip_name
  resource_group_name     = data.azurerm_resource_group.azlb.name
  ddos_protection_mode    = var.pip_ddos_protection_mode
  ddos_protection_plan_id = var.pip_ddos_protection_plan_id
  domain_name_label       = var.pip_domain_name_label
  edge_zone               = var.edge_zone
  idle_timeout_in_minutes = var.pip_idle_timeout_in_minutes
  ip_tags                 = var.pip_ip_tags
  ip_version              = var.pip_ip_version
  public_ip_prefix_id     = var.pip_public_ip_prefix_id
  reverse_fqdn            = var.pip_reverse_fqdn
  sku                     = var.pip_sku
  sku_tier                = var.pip_sku_tier
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "d8466522dbee909d833e8f6c51c4c7ec587496d5"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-01-16 05:50:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-loadbalancer"
    avm_yor_trace            = "4b18ce8b-437c-4567-be4b-ed2fa814080a"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "azlb"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
  zones = var.pip_zones
}

resource "azurerm_lb" "azlb" {
  location            = coalesce(var.location, data.azurerm_resource_group.azlb.location)
  name                = local.lb_name
  resource_group_name = data.azurerm_resource_group.azlb.name
  edge_zone           = var.edge_zone
  sku                 = var.lb_sku
  sku_tier            = var.lb_sku_tier
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "3b4dfbcc5c5c3ffe20327f21ab16ef2464ed94aa"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-01-31 02:40:02"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-loadbalancer"
    avm_yor_trace            = "42b03ba7-cc8e-4864-87c0-468da1a6383d"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "azlb"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  frontend_ip_configuration {
    name                          = var.frontend_name
    private_ip_address            = var.frontend_private_ip_address
    private_ip_address_allocation = var.frontend_private_ip_address_allocation
    private_ip_address_version    = var.frontend_private_ip_address_version
    public_ip_address_id          = try(azurerm_public_ip.azlb[0].id, null)
    subnet_id                     = local.subnet_id
  }

  lifecycle {
    precondition {
      condition     = var.frontend_subnet_name == null || var.frontend_subnet_name == "" || var.frontend_subnet_id == null || var.frontend_subnet_id == ""
      error_message = "frontend_subnet_name or frontend_vent_name cannot exist if frontend_subnet_id exists."
    }
  }
}

resource "azurerm_lb_backend_address_pool" "azlb" {
  loadbalancer_id = azurerm_lb.azlb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "azlb" {
  count = length(var.remote_port)

  backend_port                   = element(var.remote_port[element(keys(var.remote_port), count.index)], 1)
  frontend_ip_configuration_name = var.frontend_name
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = "VM-${count.index}"
  protocol                       = "Tcp"
  resource_group_name            = data.azurerm_resource_group.azlb.name
  frontend_port                  = "5000${count.index + 1}"
}

resource "azurerm_lb_probe" "azlb" {
  count = length(var.lb_probe)

  loadbalancer_id     = azurerm_lb.azlb.id
  name                = element(keys(var.lb_probe), count.index)
  port                = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 1)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  protocol            = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 0)
  request_path        = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 2)
}

resource "azurerm_lb_rule" "azlb" {
  count = length(var.lb_port)

  backend_port                   = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  frontend_ip_configuration_name = var.frontend_name
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = element(keys(var.lb_port), count.index)
  protocol                       = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.azlb.id]
  disable_outbound_snat          = var.disable_outbound_snat
  enable_floating_ip             = var.lb_floating_ip_enabled
  idle_timeout_in_minutes        = 5
  probe_id                       = element(azurerm_lb_probe.azlb[*].id, count.index)
}
