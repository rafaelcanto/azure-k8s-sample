variable "environment_type" {
  default     = "dev"
}

variable "project_name" {
  default = "Azure Enteprise POC"
}


variable "location" {
  default = "eastus"
}


variable "client_id" {
  default = "e73fab27-66f4-4bfb-be79-4d4a508bb215"
}
variable "client_secret" {
  default = "84bb1133-d253-4507-98c1-b968a9e116ce"
}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "./pubkey.rsa"
}

variable "dns_prefix" {
  default = "azenterprise"
}

variable cluster_name {
  default = "k8stest"
}

variable resource_group_name {
  default = "rg-k8s-cluster-01"
}


variable log_analytics_workspace_name {
  default = "la-azure-enterprise-poc-workspace"
}

variable log_analytics_workspace_location {
  default = "eastus"
}

variable log_analytics_workspace_sku {
  default = "PerGB2018"
}
