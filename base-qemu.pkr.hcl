source "qemu" "base" {
  accelerator       = var.qemu_accelerator
  display           = var.qemu_display
  boot_wait         = var.qemu_boot_wait
  disk_cache        = "none"
  disk_compression  = true
  disk_discard      = "unmap"
  disk_interface    = "virtio"
  disk_size         = "10G"
  format            = var.qemu_disk_format
  headless          = var.qemu_headless
  cd_label          = "install_data"
  net_device        = "virtio-net"
  cpus              = 2
  cpu_model         = var.qemu_cpu_model
  memory            = 2048
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
  source "source.qemu.base" {
    name             = "base-alma9"
    vm_name          = format("base-alma9.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-alma9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = true,
        repo_file       = "alma9",
        parts_file      = "ext4",
        network_manager = "networkd",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.alma9_checksum
    iso_url      = var.alma9_iso
  }

  ### CentOS ###
  source "source.qemu.base" {
    name             = "base-cs8"
    vm_name          = format("base-cs8.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-cs8"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = false,
        repo_file       = "cs8",
        parts_file      = "ext4",
        network_manager = "NetworkManager",
      }),
    }
    boot_command = local.efi_command
    iso_checksum = var.cs8_checksum
    iso_url      = var.cs8_iso
  }

  source "source.qemu.base" {
    name             = "base-cs9"
    vm_name          = format("base-cs9.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-cs9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = true,
        repo_file       = "cs9",
        parts_file      = "ext4",
        network_manager = "NetworkManager",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.cs9_checksum
    iso_url      = var.cs9_iso
  }

  ### Fedora ###
  source "source.qemu.base" {
    name             = "base-fedora37_btrfs"
    vm_name          = format("base-fedora37_btrfs.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-fedora37_btrfs"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = true,
        repo_file       = "fedora",
        parts_file      = "fedora-btrfs",
        network_manager = "networkd",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.fedora_checksum
    iso_url      = var.fedora_iso
  }

  ### Rocky Linux ###
  source "source.qemu.base" {
    name             = "base-rocky8"
    vm_name          = format("base-rocky8.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-rocky8"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = false,
        repo_file       = "rocky8",
        parts_file      = "ext4",
        network_manager = "networkd",
      }),
    }
    boot_command = local.efi_command
    iso_checksum = var.rocky8_checksum
    iso_url      = var.rocky8_iso
  }

  source "source.qemu.base" {
    name             = "base-rocky9"
    vm_name          = format("base-rocky9.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-rocky9"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax   = true,
        repo_file       = "rocky9",
        parts_file      = "ext4",
        network_manager = "networkd",
      }),
    }
    boot_command = local.efi_el9_command
    iso_checksum = var.rocky9_checksum
    iso_url      = var.rocky9_iso
  }

  ### Debian 11 ###
  source "source.qemu.base" {
    name             = "base-debian11"
    vm_name          = format("base-debian11.%s", var.qemu_disk_format)
    output_directory = "artifacts/base-debian11"
    cd_content = {
      "preseed.cfg" = templatefile("preseed.cfg.pkrtpl.hcl", {
        parts_file = "regular",
      }),
    }
    boot_command = local.deb_command
    iso_checksum = var.debian11_checksum
    iso_url      = var.debian11_iso
  }
}
