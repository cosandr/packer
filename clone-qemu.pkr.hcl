source "qemu" "clone" {
  accelerator      = "kvm"
  boot_wait        = "5s"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_interface   = "virtio"
  disk_size        = "10G"
  disk_image       = true
  format           = "qcow2"
  headless         = var.qemu_headless
  net_device       = "virtio-net"
  cpus             = 2
  memory           = 2048
  qemuargs = [
    ["-cpu", "host"],
  ]
  machine_type      = "q35"
  shutdown_command  = "shutdown -P now"
  ssh_timeout       = "20m"
  ssh_username      = "root"
  ssh_password      = var.ssh_password
  efi_firmware_code = var.qemu_efi_code
  efi_firmware_vars = var.qemu_efi_vars
  iso_checksum      = "none"
}

build {
  ### Alma Linux ###
  source "source.qemu.clone" {
    name             = "alma9_packer"
    vm_name          = "alma9_packer.qcow2"
    output_directory = "artifacts/alma9_packer"
    iso_url          = "artifacts/base-alma9/base-alma9.qcow2"
  }

  ### CentOS ###
  source "source.qemu.clone" {
    name             = "cs8_packer"
    vm_name          = "cs8_packer.qcow2"
    output_directory = "artifacts/cs8_packer"
    iso_url          = "artifacts/base-cs8/base-cs8.qcow2"
  }

  source "source.qemu.clone" {
    name             = "cs9_packer"
    vm_name          = "cs9_packer.qcow2"
    output_directory = "artifacts/cs9_packer"
    iso_url          = "artifacts/base-cs9/base-cs9.qcow2"
  }

  ### Fedora ###
  source "source.qemu.clone" {
    name             = "fedora37_btrfs_packer"
    vm_name          = "fedora37_btrfs_packer.qcow2"
    output_directory = "artifacts/fedora37_btrfs_packer"
    iso_url          = "artifacts/base-fedora37_btrfs/base-fedora37_btrfs.qcow2"
  }

  ### Rocky Linux ###
  source "source.qemu.clone" {
    name             = "rocky8_packer"
    vm_name          = "rocky8_packer.qcow2"
    output_directory = "artifacts/rocky8_packer"
    iso_url          = "artifacts/base-rocky8/base-rocky8.qcow2"
  }

  source "source.qemu.clone" {
    name             = "rocky9_packer"
    vm_name          = "rocky9_packer.qcow2"
    output_directory = "artifacts/rocky9_packer"
    iso_url          = "artifacts/base-rocky9/base-rocky9.qcow2"
  }

  ### Debian 11 ###
  source "source.qemu.clone" {
    name             = "debian11_packer"
    vm_name          = "debian11_packer.qcow2"
    output_directory = "artifacts/debian11_packer"
    iso_url          = "artifacts/base-debian11_packer/base-debian11_packer.qcow2"
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/common.yml"
    galaxy_file      = "./ansible/common.requirements.yml"
    ansible_env_vars = local.ansible_env_vars
    user             = "root"
    use_proxy        = false
    extra_arguments = [
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}"
    ]
  }

  provisioner "shell" {
    script = "./scripts/cleanup.sh"
  }

}
