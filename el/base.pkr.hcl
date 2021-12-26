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
}

source "vsphere-iso" "base-el" {
  vcenter_server           = var.vcenter_server
  username                 = var.vcenter_user
  password                 = var.vcenter_pass
  insecure_connection      = true
  datacenter               = var.vcenter_datacenter
  cluster                  = var.vcenter_cluster
  datastore                = var.vcenter_datastore
  folder                   = "Discovered virtual machine"
  boot_wait                = "5s"
  disk_controller_type     = ["pvscsi"]
  storage {
    disk_size              = 10000
    disk_thin_provisioned  = true
    disk_controller_index  = 0
  }
  network_adapters {
      network = "VM"
      network_card = "vmxnet3"
  }
  cd_label                 = "install_data"
  remove_cdrom             = true
  shutdown_command         = "shutdown -P now"
  ssh_timeout              = "900s"
  ssh_username             = "root"
  ssh_password             = var.ssh_password
  CPUs                     = 4
  RAM                      = 4096
}

build {
  source "source.vsphere-iso.base-el" {
    name          = "base-rocky"
    vm_name       = "base-rocky"
    guest_os_type = "centos8_64Guest"
    cd_files      =  ["./rocky8/ks.cfg"]
    firmware      = "efi"
    boot_command  = local.efi_command
    iso_checksum  = "file:https://download.rockylinux.org/pub/rocky/8/isos/x86_64/CHECKSUM"
    iso_url       = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.5-x86_64-minimal.iso"
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-cs8"
    vm_name       = "base-cs8"
    guest_os_type = "centos8_64Guest"
    cd_files      =  ["./cs8/ks.cfg"]
    firmware      = "efi"
    boot_command  = local.efi_command
    # http://isoredirect.centos.org/centos/8-stream/isos/x86_64/
    iso_checksum  = "file:https://mirror.zetup.net/CentOS/8-stream/isos/x86_64/CHECKSUM"
    iso_url       = "https://mirror.zetup.net/CentOS/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso"
  }

  source "source.vsphere-iso.base-el" {
    name          = "base-cs9"
    vm_name       = "base-cs9"
    guest_os_type = "rhel9_64Guest"
    cd_files      =  ["./cs9/ks.cfg"]
    firmware      = "bios"
    boot_command  = local.bios_command
    # https://admin.fedoraproject.org/mirrormanager/mirrors/CentOS
    # EFI currently broken
    iso_checksum  = "file:https://linuxsoft.cern.ch/centos-stream/9-stream/BaseOS/x86_64/iso/SHA256SUM"
    iso_url       = "https://linuxsoft.cern.ch/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-20211222.0-x86_64-dvd1.iso"
  }

  post-processor "vsphere-template" {
    host          = var.vcenter_server
    username      = var.vcenter_user
    password      = var.vcenter_pass
    insecure      = true
    datacenter    = var.vcenter_datacenter
    reregister_vm = false
    folder        = "/templates"
  }
}
