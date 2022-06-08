terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url          = ""
  pm_api_token_id     = ""
  pm_api_token_secret = ""
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "media-server" {
  count       = 1
  name        = "plex"
  vmid        = "200"
  target_node = "milkyway"
  clone       = "ubuntu-2004-cloud"
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
  count = 1
  name = "media-manager"
  vmid = "201"
  target_node = "milkyway"
  clone = "ubuntu-2004-cloud"
  agent = 1
  os_type = "cloud-init"
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

