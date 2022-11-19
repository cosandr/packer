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
  ssh_timeout       = "20m"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  efi_firmware_code = var.qemu_efi_code
  efi_firmware_vars = var.qemu_efi_vars
}

build {
  ### Alma Linux ###
  source "source.qemu.base-el" {
    name             = "base-alma9"
    vm_name          = "base-alma9.qcow2"
    output_directory = "artifacts/base-alma9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "alma9",
        parts_file    = "ext4",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.alma9_checksum
    iso_url      = var.alma9_iso
  }

  ### CentOS ###
  source "source.vsphere-iso.base-el" {
    name             = "base-cs8"
    vm_name          = "base-cs8"
    output_directory = "artifacts/base-cs8"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = false,
        repo_file     = "cs8",
        parts_file    = "ext4",
      }),
    }
    boot_command = local.efi_command
    iso_checksum = var.cs8_checksum
    iso_url      = var.cs8_iso
  }

  source "source.vsphere-iso.base-el" {
    name             = "base-cs9"
    vm_name          = "base-cs9"
    output_directory = "artifacts/base-cs9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "cs9",
        parts_file    = "ext4",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.cs9_checksum
    iso_url      = var.cs9_iso
  }

  ### Fedora ###
  source "source.qemu.base-el" {
    name             = "base-fedora37_btrfs"
    vm_name          = "base-fedora37_btrfs.qcow2"
    output_directory = "artifacts/base-fedora37_btrfs"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "fedora",
        parts_file    = "fedora-btrfs",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.fedora_checksum
    iso_url      = var.fedora_iso
  }

  ### Rocky Linux ###
  source "source.qemu.base-el" {
    name             = "base-rocky8"
    vm_name          = "base-rocky8.qcow2"
    output_directory = "artifacts/base-rocky8"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = false,
        repo_file     = "rocky8",
        parts_file    = "ext4",
      }),
    }
    boot_command = local.efi_command
    iso_checksum = var.rocky8_checksum
    iso_url      = var.rocky8_iso
  }

  source "source.qemu.base-el" {
    name             = "base-rocky9"
    vm_name          = "base-rocky9.qcow2"
    output_directory = "artifacts/base-rocky9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "rocky9",
        parts_file    = "ext4",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.rocky9_checksum
    iso_url      = var.rocky9_iso
  }
}
