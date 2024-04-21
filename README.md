# Packer templates

Type faster by setting
```
export PACKER_KEY_INTERVAL=25ms
```

## Libvirt

Base images are built using qemu on the localhost. To build with GUI, include `-var qemu_headless=false`

```sh
# Build on an Archlinux host
packer build -var-file arch.pkrvars.hcl -only 'qemu.base*' -except '*cs*' .
# Build on an M1 Mac, note that it is S L O W
packer build -var-file mac.pkrvars.hcl -only 'qemu.base*' -except '*cs*' .
```

If building clones on localhost also, run `copy-artifacts.sh` with the "-s" option.

Build clones with

```sh
packer build -var-file arch.pkrvars.hcl -only 'qemu.*_packer' -except '*cs*' .
```

Copy images to theia

```sh
find ./artifacts -type f -name '*_packer.*' -exec sh -c 'rsync -zvhu --progress {} root@theia:/mnt/ceph/libvirt/"$(basename {})"' \;
```

Force install galaxy requirements

```sh
for f in ansible/*.requirements.yml; do ansible-galaxy install --force -r "$f"; done
```

### Debian preseed

[Official documentation](https://wiki.debian.org/DebianInstaller/Preseed)

[All options for Debian 11](https://preseed.debian.net/debian-preseed/bullseye/amd64-main-full.txt)
