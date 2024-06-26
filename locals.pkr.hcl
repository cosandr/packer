locals {
  ansible_env_vars = [
    "ANSIBLE_HOST_KEY_CHECKING=False",
    "ANSIBLE_NOCOLOR=True",
    # "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s'"
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
