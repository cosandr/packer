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

%packages --inst-langs=en_US.utf8 --ignoremissing --excludedocs
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
%{ if network_manager == "networkd" ~}
-NetworkManager*
%{ endif ~}
%end

%post --interpreter=/usr/bin/sh
if $(virt-what | grep -q vmware); then
  dnf install -y open-vm-tools
elif $(virt-what | grep -qE 'kvm|qemu'); then
  dnf install -y qemu-guest-agent
fi

if [ "$(rpm -E %rhel)" -ge 9 ] || [ "$(rpm -E %fedora)" -ge 32 ]; then
  cat > /etc/ssh/sshd_config.d/90-root-pass.conf << EOF
PasswordAuthentication yes
PermitRootLogin yes
MaxAuthTries 30
EOF
fi

if [ "$(rpm -E %fedora)" -ge 41 ]; then
  dnf install -y python3-libdnf5
fi

# Install rocky-release-security
if [ "$(rpm -E %dist_name)" = "Rocky Linux" ]; then
  dnf install -y rocky-release-security
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-SIG-Security
fi

%{ if network_manager == "networkd" ~}
# Install EPEL if not Fedora
if [ "$(rpm -E %fedora)" = "%fedora" ]; then
  dnf config-manager --set-enabled crb
  dnf install -y epel-release
fi

dnf install -y systemd-networkd

cat <<EOF > /etc/systemd/network/dhcp.network
[Match]
Type=ether

[Network]
DHCP=yes
EOF

systemctl enable systemd-networkd

cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

rm -rfv /etc/NetworkManager /usr/lib/NetworkManager
%{ endif ~}
%end
