variable "cluster" {
  description = "Talos cluster configuration"
  type = object({
    name               = string
    vip_address        = string
    kubernetes_version = string
    talos_version      = string
    cni                = string
    pod_cidr           = string
    service_cidr       = string
  })
  default = {
    name               = "myCluster"
    vip_address        = "10.0.0.30"
    kubernetes_version = "v1.30.2"
    talos_version      = "v1.7.5"
    cni                = "flannel"
    pod_cidr           = "10.244.0.0/16"
    service_cidr       = "10.96.0.0/12"
  }
}

variable "node_data" {
  description = "Talos Node configuration"
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
  default = {
    default_gateway = "10.0.0.1"
    dns_endpoint    = "1.1.1.1"
    ntp_endpoint    = "time.cloudflare.com"

    control_plane = {
      nodes = {
        "10.0.0.31" = {
          install_disk = "/dev/sda"
        },
        "10.0.0.32" = {
          install_disk = "/dev/sda"
        },
        "10.0.0.33" = {
          install_disk = "/dev/sda"
        }
      }
    }

    worker = {
      nodes = {
        "10.0.0.34" = {
          install_disk = "/dev/sda"
        },
        "10.0.0.35" = {
          install_disk = "/dev/sda"
        },
        "10.0.0.36" = {
          install_disk = "/dev/sda"
        }
      }
    }
  }
}

variable "extra_global_config" {
  description = "Extra global configuration"
  type        = string
  default     = ""
}

variable "extra_controlplane_config" {
  description = "Extra control plane configuration"
  type        = string
  default     = ""
}

variable "extra_worker_config" {
  description = "Extra worker configuration"
  type        = string
  default     = ""
}
