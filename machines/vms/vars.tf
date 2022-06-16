variable "ssh_key" {
    type = string
    description = "public key for ssh connection"
    default = ""
}

variable "base_image" {
    type = string
    description = "Cloud Image template on Proxmox"
    deafult = "ubuntu-2004-cloud"
}