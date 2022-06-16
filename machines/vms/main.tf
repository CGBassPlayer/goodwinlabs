terraform {
  required_version = ">= 0.14"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.10"
    }

    ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "2.2.0"
    }
  }

  backend "s3" {
    bucket = var.bucket
    key    = var.key

    endpoint = var.endpoint

    access_key = var.access_key
    secret_key = var.secret_key

    region                      = var.region
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

provider "ansiblevault" {
  alias = "vault"
  vault_path = ""
  root_folder = "../vaults/secrets.yml"
}

data "ansiblevault_path" "proxmox_api_url" {
  provider = ansiblevault.vault
  path     = "./secrets.yml"
  key      = "proxmox.api_url"
}

data "ansiblevault_path" "proxmox_token_id" {
  provider = ansiblevault.vault
  path     = "./secrets.yml"
  key      = "proxmox.api_token_id"
}

data "ansiblevault_path" "proxmox_token_secret" {
  provider = ansiblevault.vault
  path     = "./secrets.yml"
  key      = "proxmox.api_token_secret"
}

provider "proxmox" {
  pm_api_url          = data.ansiblevault_path.proxmox_api_url.value
  pm_api_token_id     = data.ansiblevault_path.proxmox_token_id.value
  pm_api_token_secret = data.ansiblevault_path.proxmox_token_secret.value
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "media-server" {
  count       = 1
  name        = "plex"
  vmid        = "200"
  target_node = "milkyway"
  clone       = var.base_image
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "50G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.50/24,gw=192.168.0.1"
}

resource "proxmox_vm_qemu" "media-manager" {
  count       = 1
  name        = "media-manager"
  vmid        = "201"
  target_node = "milkyway"
  clone       = var.base_image
  agent       = 1
  os_type     = "cloud-init"
  cores       = 4
  sockets     = 1
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.51/24,gw=192.168.0.1"
}

resource "proxmox_vm_qemu" "pi_hole" {
  count       = 1
  name        = "pihole"
  vmid        = "202"
  target_node = "recyclebin"
  clone       = var.base_image
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "15G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.36/24,gw=192.168.0.1"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("../../templates/hosts.tmpl",
    {
      # Old regex = (\\b25[0-5]|\\b2[0-4][0-9]|\\b[01]?[0-9][0-9]?)(\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}
      media_managers = [
        for ip in proxmox_vm_qemu.media-manager.*.ifconfig0 :
        regex("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}",
          ip
        )
      ]
      media_servers = [
        for ip in proxmox_vm_qemu.media-server.*.ifconfig0 :
        regex("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}",
          ip
        )
      ]
      home_apps = [
        for ip in proxmox_vm_qemu.main-docker.*.ifconfig0 :
        regex("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}",
          ip
        )
      ]
      pi_holes = [
        for ip in proxmox_vm_qemu.pi_hole.*.ifconfig0 :
        regex("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}",
          ip
        )
      ]
    }
  )
  filename = "../../applications/hosts"
}
