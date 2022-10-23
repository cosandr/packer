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
