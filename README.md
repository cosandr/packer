# Packer templates

Type faster by setting
```
export PACKER_KEY_INTERVAL=25ms
```

## Libvirt

Base images are built using qemu on the localhost.

```sh
# Build on an Archlinux host
packer build -var-file arch.pkrvars.hcl -var-file local.pkrvars.hcl -only 'qemu.base*' .
```

If building clones on localhost also, run `copy-artifacts.sh` with the "-s" option.

Build clones with

```sh
packer build -var-file arch.pkrvars.hcl -var-file local.pkrvars.hcl -only 'qemu.*_packer' .
```

Copy images to theia

```sh
find ./artifacts -type f -name '*_packer.*' -exec sh -c 'rsync -vhu --progress {} root@theia:/mnt/ceph/libvirt/"$(basename {})"' \;
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
