source "qemu" "base-el" {
  accelerator      = "kvm"
  boot_wait        = "5s"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_interface   = "virtio"
  disk_size        = "10G"
  format           = "qcow2"
  headless         = true
  cd_label         = "install_data"
  net_device       = "virtio-net"
  cpus             = 2
  memory           = 2048
  qemuargs = [
    ["-cpu", "host"],
  ]
  machine_type      = "q35"
  shutdown_command  = "shutdown -P now"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  efi_firmware_code = var.qemu_efi_code
  efi_firmware_vars = var.qemu_efi_vars
}

build {
  source "source.qemu.base-el" {
    name             = "base-rocky8"
    vm_name          = "base-rocky8.qcow2"
    output_directory = "artifacts/base-rocky8"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", { el_version = "8.7" }),
    }
    boot_command = local.efi_command
    iso_checksum = "file:https://download.rockylinux.org/pub/rocky/8/isos/x86_64/CHECKSUM"
    iso_url      = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.7-x86_64-boot.iso"
  }

  source "source.qemu.base-el" {
    name             = "base-rocky9"
    vm_name          = "base-rocky9.qcow2"
    output_directory = "artifacts/base-rocky9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", { el_version = "9.0" }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = "file:https://download.rockylinux.org/pub/rocky/9/isos/x86_64/CHECKSUM"
    iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.0-x86_64-boot.iso"
  }
}
