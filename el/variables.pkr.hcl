variable "vcenter_pass" {
  type      = string
  sensitive = true
}

variable "vcenter_server" { default = "vcenter.hlab.no" }
variable "vcenter_user" { default = "administrator@vsphere.local" }
variable "vcenter_datacenter" { default = "Home" }
variable "vcenter_cluster" { default = "Home" }
variable "vcenter_datastore" { default = "TrueNAS-VM" }
variable "ssh_password" { default = "usedDuringInstallat1on" }
variable "qemu_efi_code" { default = "/usr/share/edk2-ovmf/x64/OVMF_CODE.fd" }
variable "qemu_efi_vars" { default = "/usr/share/edk2-ovmf/x64/OVMF_VARS.fd" }
variable "libvirt_uri" { default = "qemu+ssh://root@theia/system" }
variable "libvirt_net_type" { default = "managed" }
