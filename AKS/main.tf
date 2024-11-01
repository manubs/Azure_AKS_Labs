# Generate random resource group name

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "manoj1"
}

/* resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
} */

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

/* resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
 */

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.aks_cluster_name  # Use the hardcoded name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-${var.aks_cluster_name}"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D4pds_v6"
    node_count = 1
  }
  linux_profile {
      admin_username = var.username

      ssh_key {
        key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
      }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
