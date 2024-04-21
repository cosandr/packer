source "vsphere-clone" "el" {
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_user
  password            = var.vcenter_pass
  insecure_connection = true
  datacenter          = var.vcenter_datacenter
  cluster             = var.vcenter_cluster
  datastore           = var.vcenter_datastore
  folder              = "templates"
  ssh_username        = "root"
  ssh_password        = var.ssh_password
  convert_to_template = true
}

build {
  source "source.vsphere-clone.el" {
    name     = "rocky_packer"
    vm_name  = "rocky_packer"
    template = "templates/base-rocky"
  }

  source "source.vsphere-clone.el" {
    name     = "rocky9_packer"
    vm_name  = "rocky9_packer"
    template = "templates/base-rocky9"
  }

  source "source.vsphere-clone.el" {
    name     = "cs9_packer"
    vm_name  = "cs9_packer"
    template = "templates/base-cs9"
  }

  source "source.vsphere-clone.el" {
    name     = "fedora36_btrfs_packer"
    vm_name  = "fedora36_btrfs_packer"
    template = "templates/base-fedora36_btrfs"
  }

  source "source.vsphere-clone.el" {
    name     = "alma9_packer"
    vm_name  = "alma9_packer"
    template = "templates/base-alma9"
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
