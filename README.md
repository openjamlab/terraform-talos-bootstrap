<h1 align="center">Talos Bootstrap Terraform Module</h1>
<p align="center"><i>Terraform module to bootstrap and configure machines using Talos Linux. </i></p>
<div align="center">
<a href="[https://github.com/openjamlab/terraform-talos-bootstrap/stargazers](https://github.com/openjamlab/terraform-talos-bootstrap/stargazers)"><img src="https://img.shields.io/github/stars/openjamlab/terraform-talos-bootstrap?style=for-the-badge" alt="Stars Badge"/></a>
<a href="https://github.com/openjamlab/terraform-talos-bootstrap/pulls"><img src="https://img.shields.io/github/issues-pr/openjamlab/terraform-talos-bootstrap?style=for-the-badge" alt="Pull Requests Badge"/></a>
<a href="https://github.com/openjamlab/terraform-talos-bootstrap/issues"><img src="https://img.shields.io/github/issues/openjamlab/terraform-talos-bootstrap?style=for-the-badge" alt="Issues Badge"/></a>
<a href="https://github.com/openjamlab/terraform-talos-bootstrap/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/openjamlab/terraform-talos-bootstrap?style=for-the-badge"></a>
<a href="https://github.com/openjamlab/terraform-talos-bootstrap/blob/master/LICENCE"><img src="https://img.shields.io/github/license/openjamlab/terraform-talos-bootstrap?style=for-the-badge" alt="Licence Badge"/></a>
</div>

## Usage

```terraform
module "bootstrap" {
  source  = "openjamlab/bootstrap/talos"
  version = "the-latest-version-of-the-module"

  cluster = {
    name               = "myCluster"
    vip_address        = "10.0.0.30"
    kubernetes_version = "v1.30.2"
    talos_version      = "v1.7.5"
    cni                = "flannel"
    pod_cidr           = "10.244.0.0/16"
    service_cidr       = "10.96.0.0/12"
  }

  node_data = {
    default_gateway = "10.0.0.1"
    dns_endpoint    = "1.1.1.1"
    ntp_endpoint    = "time.cloudflare.com"

    control_plane = {
      nodes = {
      /*
      Nodes MUST be valid IPv4 addresses.
      */
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
      /*
      Nodes MUST be valid IPv4 addresses.
      */
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

  extra_global_config = ""

  extra_controlplane_config = ""
    
  extra_worker_config = ""
}
```
## Get kubeconfig & talosconfig

Create an output.tf file with the following contents.

```terraform
output "talosconfig" {
  value     = module.talos.talosconfig
  sensitive = true
}

output "kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}
```

Run the following commands to write kubeconfig and talosconfig files to local.

```
terraform output -raw kubeconfig > ~/.kube/config
terraform output -raw talosconfig > ~/.talos/config
```

## Adding Extra Configuration

You can extend the configuration of the Talos nodes using the `extra_global_config`, `extra_controlplane_config`, and `extra_worker_config` variables. Applying custom configuration can have unintended consequences and is not covered by the support scope of this module.

```terraform
module "bootstrap" {
  ...
  extra_global_config = <<EOF
    # Example control plane and worker configuration
    machine:
      install:
        wipe: false
    EOF

  extra_controlplane_config = <<EOF
    # Add control plane specific configurations here
    EOF
    
  extra_worker_config = <<EOF
    # Add worker node specific configurations here
    EOF
}
```