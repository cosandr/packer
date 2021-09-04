
source "qemu" "deb" {
    accelerator       = "kvm"
    boot_command      = [
      "<esc><wait>",
      "install ",
      "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
      "debian-installer=en_US.UTF-8 ",
      "auto ",
      "locale=en_US.UTF-8 ",
      "kbd-chooser/method=us ",
      "keyboard-configuration/xkb-keymap=us ",
      "netcfg/get_hostname={{ .Name }} ",
      "fb=false ",
      "debconf/frontend=noninteractive ",
      "console-setup/ask_detect=false ",
      "console-keymaps-at/keymap=us ",
      "grub-installer/bootdev=/dev/sda ",
      "<enter><wait>"
    ]
    boot_wait         = "5s"
    http_directory    = "http"
    cpus              = 2
    headless          = false
    memory            = 2048
    disk_interface    = "virtio"
    disk_size         = "5G"
    format            = "qcow2"
    iso_checksum      = "file:https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"
    iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso"
    net_device        = "virtio-net"
    output_directory  = "output"
    shutdown_command  = "echo 'packer' | shutdown -P now"
    ssh_password      = "definitelynotf!n4l"
    ssh_timeout       = "20m"
    ssh_username      = "root"
    vm_name           = "pkrdeb11"
}

build {
  sources = ["source.qemu.deb"]
}
