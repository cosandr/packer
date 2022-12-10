# Packer templates

Type faster by setting
```
export PACKER_KEY_INTERVAL=25ms
```

## Libvirt

Base images are built using qemu on the localhost,
they must be copied to the default libvirt pool before building the final images.

```sh
# Build on an Archlinux host
packer build -var-file arch.pkrvars.hcl -var-file local.pkrvars.hcl -only 'qemu*' .
```

If building clones on localhost also, run `copy-artifacts.sh` with the "-s" option.

Build clones with

```sh
packer build -parallel-builds=1 -var-file arch.pkrvars.hcl -var-file local.pkrvars.hcl -only 'libvirt*' .
```

Delete temporary domains

```sh
for vm in $(virsh list --name --inactive); do [[ $vm = packer-* ]] && virsh undefine --nvram --tpm "$vm"; done
```

Copy images to theia

```sh
find /var/lib/libvirt/images -name '*_packer.qcow2' -exec sudo chmod 644 {} \; -exec rsync -vhu --progress {} root@theia:{} \;
```

## VMware

vSphere vars from gopass (in root of repo)

```sh
cat <<EOF > home.auto.pkrvars.hcl
vcenter_server = "$(gopass show -o terraform/vsphere_server)"
vcenter_pass = "$(gopass show -o terraform/vsphere_password)"
EOF
```

Build all base image

```sh
packer build -only '*base*' .
```

Build just one OS base image

```sh
packer build -only '*base*rocky*' .
packer build -only '*base*cs8*' .
packer build -only '*base*cs9*' .
```

Build final images (*MUST* build base prior, as well as manually move them into `/templates`)

```sh
packer build -only '*clone*' .
```

Build one final image

```sh
packer build -only '*clone*rocky*' .
packer build -only '*clone*cs8*' .
packer build -only '*clone*cs9*' .
```

Force install galaxy requirements

```sh
for f in ansible/*.requirements.yml; do ansible-galaxy install --force -r "$f"; done
```

### Debian preseed

[Official documentation](https://wiki.debian.org/DebianInstaller/Preseed)

[All options for Debian 11](https://preseed.debian.net/debian-preseed/bullseye/amd64-main-full.txt)
