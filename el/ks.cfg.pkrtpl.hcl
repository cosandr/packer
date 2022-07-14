text
network --activate
url --mirrorlist="https://mirrors.rockylinux.org/mirrorlist?repo=rocky-BaseOS-$releasever&arch=$basearch&country=NO,SE,DK,NL"
repo --name=rocky_appstream --mirrorlist="https://mirrors.rockylinux.org/mirrorlist?repo=rocky-AppStream-$releasever&arch=$basearch&country=NO,SE,DK,NL"
repo --name=rocky_extras --mirrorlist="https://mirrors.rockylinux.org/mirrorlist?repo=rocky-extras-$releasever&arch=$basearch&country=NO,SE,DK,NL"

skipx
lang en_US.UTF-8
keyboard us
timezone Europe/Oslo
firewall --enabled --ssh
selinux --enforcing
bootloader --location=mbr
zerombr
clearpart --all --initlabel

autopart --noswap --fstype=ext4 --type=plain

rootpw usedDuringInstallat1on

firstboot --disable

reboot

%addon com_redhat_kdump --disable
%end

%{ if el_version >= 9 ~}
%packages --inst-langs=en_US.utf8 --ignoremissing --excludedocs
%{ else ~}
%packages --instLangs=en_US.utf8 --ignoremissing --excludedocs
%{ endif ~}
@minimal-environment

binutils
cloud-utils-growpart
curl
efibootmgr
firewalld
git
htop
kernel
net-tools
nfs-utils
open-vm-tools
openssh-clients
openssh-server
python3
python3-libselinux
python3-policycoreutils
rsync
sudo
vim
wget
-plymouth
-iw*-firmware
-microcode_ctl
%end

%{ if el_version >= 9 ~}
%post --interpreter=/usr/bin/sh
cat > /etc/ssh/sshd_config.d/90-root-pass.conf << EOF
PasswordAuthentication yes
PermitRootLogin yes
EOF
%end
%{ endif ~}
