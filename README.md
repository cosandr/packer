# Packer templates

Open ports 8000:9000 in firewall from VM interface (virbr0).

```sh
# firewalld
sudo firewall-cmd --permanent --new-zone=packer
sudo firewall-cmd --permanent --zone=packer --add-interface=virbr0
sudo firewall-cmd --permanent --zone=packer --add-port=8000-9000/tcp
sudo firewall-cmd --reload
```

### Debian preseed

[Official documentation](https://wiki.debian.org/DebianInstaller/Preseed)

[All options for Debian 11](https://preseed.debian.net/debian-preseed/bullseye/amd64-main-full.txt)

## VMWare

`home.auto.pkrvars.hcl`
```hcl
vcenter_pass = "mysecretpass"
```
