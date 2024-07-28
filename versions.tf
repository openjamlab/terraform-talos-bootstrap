terraform {
  required_version = "~> 1.9.0"

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
