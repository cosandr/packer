source "vsphere-clone" "el" {
  vcenter_server           = var.vcenter_server
  username                 = var.vcenter_user
  password                 = var.vcenter_pass
  insecure_connection      = true
  datacenter               = var.vcenter_datacenter
  cluster                  = var.vcenter_cluster
  datastore                = var.vcenter_datastore
  folder                   = "templates"
  ssh_username             = "root"
  ssh_password             = var.ssh_password
  convert_to_template      = true
}

build {
  source "source.vsphere-clone.el" {
    name         = "rocky_packer"
    vm_name      = "rocky_packer"
    template     = "templates/base-rocky"
  }

  source "source.vsphere-clone.el" {
    name         = "cs8_packer"
    vm_name      = "cs8_packer"
    template     = "templates/base-cs8"
  }

  source "source.vsphere-clone.el" {
    name         = "cs9_packer"
    vm_name      = "cs9_packer"
    template     = "templates/base-cs9"
  }

  source "source.vsphere-clone.el" {
    name         = "rocky_docker_packer"
    vm_name      = "rocky_docker_packer"
    template     = "templates/base-rocky"
  }

  provisioner "ansible" {
    playbook_file = "../ansible/common.yml"
    galaxy_file = "../ansible/common.requirements.yml"
    # Prevent errors when role is already installed
    galaxy_force_install = true
    extra_arguments = [
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}"
    ]
    ansible_ssh_extra_args = []
    user = "root"
    use_proxy = false
  }

  provisioner "ansible" {
    playbook_file = "../ansible/docker.yml"
    galaxy_file = "../ansible/docker.requirements.yml"
    galaxy_force_install = true
    only = ["vsphere-clone.rocky_docker_packer"]
    ansible_ssh_extra_args = [
      "-o", "ForwardAgent=yes"
    ]
    user = "root"
    use_proxy = false
  }

  provisioner "shell" {
    script = "../scripts/cleanup.sh"
  }
}
