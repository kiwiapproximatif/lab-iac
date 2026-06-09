terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "~> 1.1.0"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

locals {
  containers = {
    "master"  = { role = "master", image = "images:ubuntu/24.04/cloud", os_family = "debian" }
    "minion1" = { role = "minion", image = "images:ubuntu/24.04/cloud", os_family = "debian" }
    "minion2" = { role = "minion", image = "images:ubuntu/24.04/cloud", os_family = "debian" }
    "minion3" = { role = "minion", image = "images:rockylinux/9/cloud", os_family = "redhat" }
  }
}

resource "incus_instance" "nodes" {
  for_each = local.containers

  name  = each.key
  image = each.value.image
  type  = "container"

  profiles = ["default"]

  config = {
    "limits.cpu"    = "2"
    "limits.memory" = "2GiB"
    "user.role"     = each.value.role
    "user.user-data" = templatefile("${path.module}/cloud-init.yml.tftpl", {
      admin_group = each.value.os_family == "debian" ? "sudo" : "wheel"
      pub_key = file("~/.ssh/id_ed25519.pub")
    })
  }
}