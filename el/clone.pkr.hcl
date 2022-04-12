locals {
  ansible_env_vars = [
    "ANSIBLE_HOST_KEY_CHECKING=False",
    "ANSIBLE_NOCOLOR=True"
  ]
  ansible_ssh_extra_args = [
    "-o", "ForwardAgent=yes",
    "-o", "ControlMaster=auto",
    "-o", "ControlPersist=60s",
  ]
}

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
    ansible_env_vars = "${local.ansible_env_vars}"
    ansible_ssh_extra_args = "${local.ansible_ssh_extra_args}"
    user = "root"
    use_proxy = false
    extra_arguments = [
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}"
    ]
  }

  provisioner "ansible" {
    only = ["vsphere-clone.rocky_docker_packer"]
    playbook_file = "../ansible/docker.yml"
    galaxy_file = "../ansible/docker.requirements.yml"
    ansible_env_vars = "${local.ansible_env_vars}"
    ansible_ssh_extra_args = "${local.ansible_ssh_extra_args}"
    user = "root"
    use_proxy = false
  }

  provisioner "shell" {
    script = "../scripts/cleanup.sh"
  }
}
