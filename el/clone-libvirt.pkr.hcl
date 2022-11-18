source "libvirt" "el" {
  libvirt_uri = var.libvirt_uri
  vcpu        = 2
  memory      = 2048
  chipset     = "q35"
  loader_type = "pflash"
  cpu_mode    = "host-model"
  loader_path = var.qemu_efi_code

  network_address_source = "agent"

  communicator {
    communicator = "ssh"
    ssh_username = "root"
    ssh_password = var.ssh_password
  }

  network_interface {
    alias = "communicator"
    type  = var.libvirt_net_type
  }
}

build {
  source "source.libvirt.el" {
    name = "rocky8_packer"

    volume {
      alias = "artifact"

      pool       = "default"
      name       = "rocky8_packer.qcow2"
      format     = "qcow2"
      capacity   = "10G"
      bus        = "virtio"
      target_dev = "vda"

      source {
        type   = "cloning"
        pool   = "default"
        volume = "base-rocky8.qcow2"
      }
    }
  }

  source "source.libvirt.el" {
    name = "rocky9_packer"

    volume {
      alias = "artifact"

      pool       = "default"
      name       = "rocky9_packer.qcow2"
      format     = "qcow2"
      capacity   = "10G"
      bus        = "virtio"
      target_dev = "vda"

      source {
        type   = "cloning"
        pool   = "default"
        volume = "base-rocky9.qcow2"
      }
    }
  }

  provisioner "ansible" {
    playbook_file    = "../ansible/common.yml"
    galaxy_file      = "../ansible/common.requirements.yml"
    ansible_env_vars = local.ansible_env_vars
    user             = "root"
    use_proxy        = false
    extra_arguments = [
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}"
    ]
  }

  provisioner "shell" {
    script = "../scripts/cleanup.sh"
  }

}
