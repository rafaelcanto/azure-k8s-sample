provider "azurerm" {
  features {}
  version = "~> 2.0"
}

locals {
  tags = {
    environment_type = var.environment_type
    project_name     = var.project_name
  }
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  workspace_name        = azurerm_log_analytics_workspace.test.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix


  # linux_profile {
  #   admin_username = "kubeadmin"
  #   ssh_key {
  #     file(var.ssh_public_key) } 
  # }

  network_profile {
    network_plugin = "azure"    
    load_balancer_sku = "standard"    
  }

  default_node_pool {
    name           = "default"
    node_count     = var.agent_count
    vm_size        = "Standard_DS1_v2"
    vnet_subnet_id = "/subscriptions/b84abf1c-f93d-4388-81c2-b18bd87aa1fb/resourceGroups/rg-dev-eastus-spoke-1/providers/Microsoft.Network/virtualNetworks/vnet-dev-eastus-spoke-1/subnets/snet-dev-spoke-1-frontend-01"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
    }
  }

  tags = {
    Environment = "Development"
  }
}
