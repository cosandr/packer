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
  default = "file:https://almalinux.uib.no/9.6/isos/x86_64/CHECKSUM"
}

# Need to update repo-alma9.cfg too
variable "alma9_iso" {
  default = "https://almalinux.uib.no/9.6/isos/x86_64/AlmaLinux-9.6-x86_64-boot.iso"
}

# https://getfedora.org/security/
variable "fedora_checksum" {
  default = "file:https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-41-1.4-x86_64-CHECKSUM"
}

# https://fedoraproject.org/en/server/download
variable "fedora_iso" {
  default = "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-netinst-x86_64-41-1.4.iso"
}

variable "rocky9_checksum" {
  default = "file:https://rockylinux.hi.no/9.6/isos/x86_64/CHECKSUM"
}

# Need to update repo-rocky9.cfg too
variable "rocky9_iso" {
  default = "https://rockylinux.hi.no/9.6/isos/x86_64/Rocky-9.6-x86_64-boot.iso"
}

variable "debian12_checksum" {
  default = "file:https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/SHA256SUMS"
}

variable "debian12_iso" {
  default = "https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
}

variable "debian13_checksum" {
  default = "file:https://cdimage.debian.org/debian-cd/13.0.0/amd64/iso-cd/SHA256SUMS"
}

variable "debian13_iso" {
  default = "https://cdimage.debian.org/debian-cd/13.0.0/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
}
