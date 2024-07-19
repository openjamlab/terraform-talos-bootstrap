variable "cluster" {
  type = object({
    name               = string
    vip_address        = string
    kubernetes_version = string
    talos_version      = string
    cni                = string
  })
}

variable "node_data" {
  type = object({
    default_gateway = string
    dns_endpoint    = string
    ntp_endpoint    = string

    control_plane   = object({
      nodes = map(object({
        install_disk = string
      }))
    })

    worker          = object({
      nodes = map(object({
        install_disk = string
      }))
    })
  })
}

variable "extra_global_config" {
  type = string
}

variable "extra_controlplane_config" {
  type = string
}

variable "extra_worker_config" {
  type = string
}
