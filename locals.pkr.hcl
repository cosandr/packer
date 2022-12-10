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
  deb_command = [
    "<wait3s>c<wait3s>",
    "linux /install.amd/vmlinuz",
    " auto-install/enable=true",
    " debconf/priority=critical",
    " file=/media/preseed.cfg",
    " noprompt --<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>",
    "<wait15s>",
    "<enter><wait>",
    "<enter><wait>",
    "<leftAltOn><f2><leftAltOff>",
    "<enter><wait>",
    "mount /dev/sr1 /media<enter>",
    "<leftAltOn><f1><leftAltOff>",
    "<down><down><down><down><enter>"
  ]
}
