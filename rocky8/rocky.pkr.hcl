source "vsphere-clone" "rocky" {
  vcenter_server           = var.vcenter_server
  username                 = var.vcenter_user
  password                 = var.vcenter_pass
  insecure_connection      = true
  datacenter               = var.vcenter_datacenter
  cluster                  = var.vcenter_cluster
  datastore                = var.vcenter_datastore
  folder                   = "Discovered virtual machine"
  template                 = "templates/base-rocky"
  ssh_username             = "root"
  ssh_password             = var.ssh_password
}

build {
  source "source.vsphere-clone.rocky" {
    name         = "rocky_packer"
    vm_name      = "rocky_packer"
  }

  source "source.vsphere-clone.rocky" {
    name         = "rocky_docker_packer"
    vm_name      = "rocky_docker_packer"
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

  post-processor "vsphere-template" {
    host          = var.vcenter_server
    username      = var.vcenter_user
    password      = var.vcenter_pass
    insecure      = true
    datacenter    = var.vcenter_datacenter
    folder        = "/templates"
    reregister_vm = false
  }
}
