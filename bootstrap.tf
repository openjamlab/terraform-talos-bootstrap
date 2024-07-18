resource "talos_machine_secrets" "this" {}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.node_data.control_plane.nodes : k]
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.nodes]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.node_data.control_plane.nodes : k][0]
}

data "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.cluster.vip_address
  wait                 = true
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.node_data.control_plane.nodes : k]
  control_plane_nodes  = [for k, v in var.node_data.control_plane.nodes : k]
  worker_nodes         = [for k, v in var.node_data.worker.nodes : k]
}
