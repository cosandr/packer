variable "vcenter_pass" {
  type      = string
  sensitive = true
}

variable "vcenter_server"     { default = "10.0.100.10" }
variable "vcenter_user"       { default = "administrator@vsphere.local" }
variable "vcenter_datacenter" { default = "Home" }
variable "vcenter_host"       { default = "10.0.100.5" }
variable "vcenter_datastore"  { default = "TrueNAS-SSD" }
variable "ssh_password"       { default = "usedDuringInstallat1on" }
