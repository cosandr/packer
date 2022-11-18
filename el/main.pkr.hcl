packer {
  required_plugins {
    libvirt = {
      version = ">= 0.4.0"
      source  = "github.com/thomasklein94/libvirt"
    }
    qemu = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
