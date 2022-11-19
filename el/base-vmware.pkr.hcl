locals {
  bios_command = [
    "<up><tab><bs><bs><bs><bs><bs>",
    "inst.ks=cdrom:LABEL=install_data:/ks.cfg",
    "<enter>",
  ]
  efi_command = [
    "<up>e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.ks=cdrom:LABEL=install_data:/ks.cfg",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
  efi_el9_command = [
    "<up>e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.ks=cdrom",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
}

source "vsphere-iso" "base-el" {
  vcenter_server       = var.vcenter_server
  username             = var.vcenter_user
  password             = var.vcenter_pass
  insecure_connection  = true
  datacenter           = var.vcenter_datacenter
  cluster              = var.vcenter_cluster
  datastore            = var.vcenter_datastore
  folder               = "templates"
  boot_wait            = "5s"
  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = 10000
    disk_thin_provisioned = true
    disk_controller_index = 0
  }
  network_adapters {
    network      = "DSwitch/VM"
    network_card = "vmxnet3"
  }
  cd_label            = "install_data"
  remove_cdrom        = true
  shutdown_command    = "shutdown -P now"
  ssh_timeout         = "900s"
  ssh_username        = "root"
  ssh_password        = var.ssh_password
  CPUs                = 4
  RAM                 = 4096
  convert_to_template = true
}

build {
  source "source.vsphere-iso.base-el" {
    name          = "base-rocky"
    vm_name       = "base-rocky"
    guest_os_type = "centos8_64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = false,
        repo_file     = "rocky8",
        parts_file    = "ext4",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_command
    iso_checksum = var.rocky8_checksum
    iso_url      = var.rocky8_iso
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-rocky9"
    vm_name       = "base-rocky9"
    guest_os_type = "centos9_64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "rocky9",
        parts_file    = "ext4",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_el9_command
    iso_checksum = var.rocky9_checksum
    iso_url      = var.rocky9_iso
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-cs8"
    vm_name       = "base-cs8"
    guest_os_type = "centos8_64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = false,
        repo_file     = "cs8",
        parts_file    = "ext4",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_command
    # http://isoredirect.centos.org/centos/8-stream/isos/x86_64/
    iso_checksum = var.cs8_checksum
    iso_url      = var.cs8_iso
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-cs9"
    vm_name       = "base-cs9"
    guest_os_type = "centos9_64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "cs9",
        parts_file    = "ext4",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_el9_command
    iso_checksum = var.cs9_checksum
    iso_url      = var.cs9_iso
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-alma9"
    vm_name       = "base-alma9"
    guest_os_type = "centos9_64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "alma9",
        parts_file    = "ext4",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_el9_command
    iso_checksum = var.alma9_checksum
    iso_url      = var.alma9_iso
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-fedora37_btrfs"
    vm_name       = "base-fedora37_btrfs"
    guest_os_type = "fedora64Guest"
    cd_content = {
      "ks.cfg" = templatefile("ks.cfg.pkrtpl.hcl", {
        new_ks_syntax = true,
        repo_file     = "fedora",
        parts_file    = "fedora-btrfs",
      }),
    }
    firmware     = "efi"
    boot_command = local.efi_el9_command
    iso_checksum = var.fedora_checksum
    iso_url      = var.fedora_iso
  }
}
