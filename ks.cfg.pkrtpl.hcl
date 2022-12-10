text
network --activate

${ file("ks.cfg.d/repo-${repo_file}.cfg") ~}

skipx
lang en_US.UTF-8
keyboard us
timezone Europe/Oslo
firewall --enabled --ssh
selinux --enforcing
services --disabled="kdump"
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200n8 no_timer_check crashkernel=auto"
zerombr
clearpart --all --initlabel

${ file("ks.cfg.d/parts-${parts_file}.cfg") ~}

rootpw usedDuringInstallat1on

firstboot --disable

reboot

%addon com_redhat_kdump --disable
%end

%{ if new_ks_syntax ~}
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
openssh-clients
openssh-server
python3
python3-libselinux
python3-policycoreutils
rsync
sudo
vim-enhanced
virt-what
wget
-plymouth
-iw*-firmware
-microcode_ctl
%end

%post --interpreter=/usr/bin/sh
if $(virt-what | grep -q vmware); then
  dnf install -y open-vm-tools
elif $(virt-what | grep -q kvm); then
  dnf install -y qemu-guest-agent
fi

if [ $(rpm -E %rhel) -ge 9 ] || [ $(rpm -E %fedora) -ge 32 ]; then
  cat > /etc/ssh/sshd_config.d/90-root-pass.conf << EOF
PasswordAuthentication yes
PermitRootLogin yes
EOF
fi
%end
