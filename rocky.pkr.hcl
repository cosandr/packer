variable "vcenter_pass" {
  type      = string
  sensitive = true
}

variable "vcenter_server"     { default = "10.0.100.10" }
variable "vcenter_user"       { default = "administrator@vsphere.local" }
variable "vcenter_datacenter" { default = "Home" }
variable "vcenter_cluster"    { default = "Home" }
variable "vcenter_datastore"  { default = "TrueNAS-SSD" }

source "vsphere-iso" "rocky" {
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
      network = "VLAN10"
      network_card = "vmxnet3"
  }
  guest_os_type            = "centos8_64Guest"
  cd_files                 =  ["./rocky8/ks.cfg"]
  cd_label                 = "install_data"
  iso_checksum             = "file:https://download.rockylinux.org/pub/rocky/8/isos/x86_64/CHECKSUM"
  iso_url                  = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-minimal.iso"
  remove_cdrom             = true
  shutdown_command         = "shutdown -P now"
  ssh_timeout              = "900s"
  ssh_username             = "root"
  CPUs                     = 2
  RAM                      = 4096
  firmware                 = "efi"
}

build {
  source "source.vsphere-iso.rocky" {
    name         = "rocky_packer"
    vm_name      = "rocky_packer"
    boot_command = [
      "<up>e<down><down><end><bs><bs><bs><bs><bs>",
      "inst.ks=cdrom:LABEL=install_data:/ks.cfg",
      "<leftCtrlOn>x<leftCtrlOff>",
    ]
  }

  source "source.vsphere-iso.rocky" {
    name         = "rocky_docker_packer"
    vm_name      = "rocky_docker_packer"
    boot_command = [
      "<up>e<down><down><end><bs><bs><bs><bs><bs>",
      "inst.ks=cdrom:LABEL=install_data:/ks.cfg",
      "<leftCtrlOn>x<leftCtrlOff>",
    ]
  }

  sources = ["source.vsphere-iso.rocky"]

  provisioner "shell" {
    script = "scripts/docker_centos.sh"
    only = ["vsphere-iso.rocky_docker_packer"]
  }

  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }

  post-processor "vsphere-template" {
    host                   = var.vcenter_server
    username               = var.vcenter_user
    password               = var.vcenter_pass
    insecure               = true
    datacenter             = var.vcenter_datacenter
    folder                 = "/packer-templates/rocky"
  }
}

