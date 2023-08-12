variable "vcenter_pass" {
  type      = string
  sensitive = true
  default   = ""
}

variable "vcenter_server" { default = "vcenter.hlab.no" }
variable "vcenter_user" { default = "administrator@vsphere.local" }
variable "vcenter_datacenter" { default = "Home" }
variable "vcenter_cluster" { default = "Home" }
variable "vcenter_datastore" { default = "TrueNAS-VM" }
variable "ssh_password" { default = "usedDuringInstallat1on" }
variable "qemu_efi_code" { default = "/usr/share/edk2-ovmf/x64/OVMF_CODE.fd" }
variable "qemu_efi_vars" { default = "/usr/share/edk2-ovmf/x64/OVMF_VARS.fd" }
variable "qemu_headless" { default = true }
variable "qemu_disk_format" { default = "raw" }
variable "qemu_boot_wait" { default = "5s" }
variable "qemu_display" { default = null }
variable "qemu_accelerator" { default = "kvm" }
variable "qemu_cpu_model" { default = "host" }

# https://mirrors.almalinux.org/
variable "alma9_checksum" {
  default = "file:https://almalinux.uib.no/9.2/isos/x86_64/CHECKSUM"
}

variable "alma9_iso" {
  default = "https://almalinux.uib.no/9.2/isos/x86_64/AlmaLinux-9.2-x86_64-boot.iso"
}

# http://isoredirect.centos.org/centos/8-stream/isos/x86_64/
variable "cs8_checksum" {
  default = "file:https://mirror.zetup.net/CentOS/8-stream/isos/x86_64/CHECKSUM"
}

variable "cs8_iso" {
  default = "https://mirror.zetup.net/CentOS/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso"
}

# http://isoredirect.centos.org/centos/9-stream/isos/x86_64/
variable "cs9_checksum" {
  default = "file:https://mirror.netsite.dk/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso.SHA256SUM"
}

variable "cs9_iso" {
  default = "https://mirror.netsite.dk/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso"
}

# https://getfedora.org/security/
variable "fedora_checksum" {
  default = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-38-1.6-x86_64-CHECKSUM"
}

# https://getfedora.org/en/server/download/
variable "fedora_iso" {
  default = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Server/x86_64/iso/Fedora-Server-netinst-x86_64-38-1.6.iso"
}

# https://rockylinux.org/download
variable "rocky8_checksum" {
  default = "file:https://download.rockylinux.org/pub/rocky/8/isos/x86_64/CHECKSUM"
}

variable "rocky8_iso" {
  default = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.8-x86_64-boot.iso"
}

variable "rocky9_checksum" {
  default = "file:https://download.rockylinux.org/pub/rocky/9/isos/x86_64/CHECKSUM"
}

variable "rocky9_iso" {
  default = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.2-x86_64-boot.iso"
}

variable "debian11_checksum" {
  default = "file:https://cdimage.debian.org/cdimage/archive/11.7.0/amd64/iso-cd/SHA256SUMS"
}

variable "debian11_iso" {
  default = "https://cdimage.debian.org/cdimage/archive/11.7.0/amd64/iso-cd/debian-11.7.0-amd64-netinst.iso"
}

variable "debian12_checksum" {
  default = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
}

variable "debian12_iso" {
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.1.0-amd64-netinst.iso"
}
