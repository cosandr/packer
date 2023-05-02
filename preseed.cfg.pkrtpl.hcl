# https://github.com/vmware-samples/packer-examples-for-vsphere/blob/cdbc6f75d28dfe3afbca4d2ed5b06a456cceafb5/builds/linux/debian/11/data/ks.pkrtpl.hcl

# Debian 11

# Locale and Keyboard
d-i debian-installer/locale string en_US
d-i keyboard-configuration/xkb-keymap select us

# Clock and Timezone
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string Europe/Oslo

# Grub and Reboot Message
d-i finish-install/reboot_in_progress note
d-i grub-installer/only_debian boolean true

# Enable serial
# Doesn't work https://bugs.launchpad.net/ubuntu/+source/grub-installer/+bug/581796
# d-i grub2/linux_cmdline_default string console=tty0 console=ttyS0,115200n8 no_timer_check
# Install grub to default location as well
d-i grub-installer/force-efi-extra-removable boolean true

# Partitioning
${ file("preseed.cfg.d/parts-${parts_file}.cfg") ~}

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Network configuration
d-i netcfg/choose_interface select auto

# Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string ftp.no.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# User Configuration
d-i passwd/root-password password usedDuringInstallat1on
d-i passwd/root-password-again password usedDuringInstallat1on
d-i passwd/make-user boolean false

# Package Configuration
d-i pkgsel/run_tasksel boolean false
d-i pkgsel/include string \
    apt-file \
    cloud-guest-utils \
    curl \
    efibootmgr \
    git \
    htop \
    man-db \
    net-tools \
    nfs-common \
    openssh-server \
    perl \
    python3-apt \
    rsync \
    sudo \
    ufw \
    vim \
    virt-what \
    wget

popularity-contest popularity-contest/participate boolean false

# Enable root password login, install guest agents and configure networking
d-i preseed/late_command string \
    in-target sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config ; \
    in-target /bin/sh -c -- 'virt-what | grep -q vmware && apt-get install -y open-vm-tools || true' ; \
    in-target /bin/sh -c -- 'virt-what | grep -qE "kvm|qemu" && apt-get install -y qemu-guest-agent || true' ; \
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=/GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 no_timer_check"/' /target/etc/default/grub ; \
    in-target bash -c 'update-grub' ; \
    in-target apt-get purge -y ifupdown && rm -rf /etc/network ; \
    echo -e "[Match]\nType=ether\n\n[Network]\nDHCP=yes\n" > /target/etc/systemd/network/dhcp.network ; \
    in-target /bin/sh -c -- 'command -v resolvectl || apt-get install -y systemd-resolved' ; \
    in-target systemctl enable systemd-networkd systemd-resolved ; \
    ln -sf /run/systemd/resolve/stub-resolv.conf /target/etc/resolv.conf ;

# Umount preseed media early
d-i preseed/early_command string \
    umount /media && echo 1 > /sys/block/sr1/device/delete ;
