terraform {
  required_version = "~> 1.7.0"

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
