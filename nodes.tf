/*
Create a random hostname for controlplane & worker nodes.
*/
resource "random_string" "nodes" {
  for_each = { for key, value in merge(var.node_data.control_plane.nodes, var.node_data.worker.nodes) : key => value }
  length   = 8
  lower    = true
  numeric  = true
  upper    = true
  special  = false
}

data "talos_machine_configuration" "nodes" {
  for_each           = { for key, value in merge(var.node_data.control_plane.nodes, var.node_data.worker.nodes) : key => value }
  cluster_name       = var.cluster.name
  cluster_endpoint   = "https://${var.cluster.vip_address}:6443"
  machine_type       = contains(keys(var.node_data.control_plane.nodes), each.key) ? "controlplane" : "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.cluster.kubernetes_version
  talos_version      = var.cluster.talos_version
}

resource "talos_machine_configuration_apply" "nodes" {
  for_each                    = { for key, value in merge(var.node_data.control_plane.nodes, var.node_data.worker.nodes) : key => value }
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.nodes[each.key].machine_configuration
  node                        = each.key
  config_patches              = flatten([
    /*
    Control Plane & Worker Config
    */
    [
      templatefile("${path.module}/templates/global.yaml.tmpl", {
        hostname        = format("%s-%s", contains(keys(var.node_data.control_plane.nodes), each.key) ? "controlplane" : "worker", random_string.nodes[each.key].result)
        ip_address      = each.key
        install_disk    = each.value.install_disk
        dns_server      = var.node_data.dns_endpoint
        default_gateway = var.node_data.default_gateway
        ntp_server      = var.node_data.ntp_endpoint
        vip_address     = var.cluster.vip_address
        extra_config    = var.extra_global_config
      })
    ],
    /*
    Control Plane Config
    */
    contains(keys(var.node_data.control_plane.nodes), each.key) ? [
      templatefile("${path.module}/templates/controlplane.yaml.tmpl", {
        vip_address  = var.cluster.vip_address
        extra_config = var.extra_controlplane_config
      })
    ] : [],
    /*
    Worker Config
    */
    contains(keys(var.node_data.worker.nodes), each.key) ? [
      templatefile("${path.module}/templates/worker.yaml.tmpl", {
        extra_config = var.extra_worker_config
      })
    ] : [],
  ])
}
