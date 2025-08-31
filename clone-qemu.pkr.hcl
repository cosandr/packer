source "qemu" "clone" {
  accelerator       = var.qemu_accelerator
  display           = var.qemu_display
  disk_cache        = "none"
  disk_compression  = true
  disk_discard      = "unmap"
  disk_interface    = "virtio"
  disk_size         = "10G"
  disk_image        = true
  format            = var.qemu_disk_format
  headless          = var.qemu_headless
  net_device        = "virtio-net"
  cpus              = 2
  cpu_model         = var.qemu_cpu_model
  memory            = 2048
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
    vm_name          = format("alma9_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/alma9_packer"
    iso_url          = format("artifacts/base-alma9/base-alma9.%s", var.qemu_disk_format)
  }

  ### Fedora ###
  source "source.qemu.clone" {
    name             = "fedora41_btrfs_packer"
    vm_name          = format("fedora41_btrfs_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/fedora41_btrfs_packer"
    iso_url          = format("artifacts/base-fedora41_btrfs/base-fedora41_btrfs.%s", var.qemu_disk_format)
  }

  ### Rocky Linux ###
  source "source.qemu.clone" {
    name             = "rocky9_packer"
    vm_name          = format("rocky9_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/rocky9_packer"
    iso_url          = format("artifacts/base-rocky9/base-rocky9.%s", var.qemu_disk_format)
  }

  source "source.qemu.clone" {
    name             = "rocky9_intelgpu_packer"
    vm_name          = format("rocky9_intelgpu_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/rocky9_intelgpu_packer"
    iso_url          = format("artifacts/base-rocky9/base-rocky9.%s", var.qemu_disk_format)
  }

  ### Debian 12 ###
  source "source.qemu.clone" {
    name             = "debian12_packer"
    vm_name          = format("debian12_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/debian12_packer"
    iso_url          = format("artifacts/base-debian12/base-debian12.%s", var.qemu_disk_format)
  }

  ### Debian 13 ###
  source "source.qemu.clone" {
    name             = "debian13_packer"
    vm_name          = format("debian13_packer.%s", var.qemu_disk_format)
    output_directory = "artifacts/debian13_packer"
    iso_url          = format("artifacts/base-debian13/base-debian13.%s", var.qemu_disk_format)
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/common.yml"
    galaxy_file      = "./ansible/common.requirements.yml"
    ansible_env_vars = local.ansible_env_vars
    ansible_ssh_extra_args = [
      "-o", "UserKnownHostsFile=/dev/null",
      "-o", "StrictHostKeyChecking=no",
    ]
    # keep_inventory_file = true
    user      = "root"
    use_proxy = false
    extra_arguments = [
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}",
      "--extra-vars", "source_name=${source.name}",
    ]
  }

  provisioner "shell" {
    script = "./scripts/cleanup.sh"
  }

}
