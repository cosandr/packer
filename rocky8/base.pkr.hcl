source "vsphere-iso" "base-rocky" {
  vcenter_server           = var.vcenter_server
  username                 = var.vcenter_user
  password                 = var.vcenter_pass
  insecure_connection      = true
  datacenter               = var.vcenter_datacenter
  cluster                  = var.vcenter_cluster
  datastore                = var.vcenter_datastore
  vm_name                  = "base-rocky"
  folder                   = "Discovered virtual machine"
  boot_wait                = "5s"
  disk_controller_type     = ["pvscsi"]
  boot_command             = [
    "<up>e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.ks=cdrom:LABEL=install_data:/ks.cfg",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
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
  cd_files                 =  ["./ks.cfg"]
  cd_label                 = "install_data"
  iso_checksum             = "file:https://download.rockylinux.org/pub/rocky/8/isos/x86_64/CHECKSUM"
  iso_url                  = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.5-x86_64-minimal.iso"
  remove_cdrom             = true
  shutdown_command         = "shutdown -P now"
  ssh_timeout              = "900s"
  ssh_username             = "root"
  ssh_password             = var.ssh_password
  CPUs                     = 4
  RAM                      = 4096
  firmware                 = "efi"
}

build {
  source "source.vsphere-iso.base-rocky" {
    name         = "base-rocky"
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
