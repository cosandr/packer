#!/bin/bash

rm -rf /etc/ssh/ssh_host_*key* /root/* /var/spool/mail/*
rm -f $HISTFILE && unset HISTFILE
HISTSIZE=0

rm -rf /usr/share/backgrounds/*
rm -f /usr/lib/locale/locale-archive
/usr/bin/localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 &> /dev/null

rpm --rebuilddb
yum clean all
rm -rf /var/cache/yum/*

cleanup=( /boot /boot/efi / )

for d in "${cleanup[@]}"; do
  if [[ ! -d "$d" ]]; then
    echo "$d doesn't exist, skip"
    continue
  fi

  fs_type="$(findmnt -nrv -o fstype "$d")"
  if [[ $fs_type = btrfs ]]; then
    btrfs scrub start -B "$d"
    btrfs balance start --full-balance "$d"
  else
    dd if=/dev/zero of="$d/zero" bs=1M
    rm -fv "$d/zero"
  fi
done

find /var/log -type f -delete

rm -fv /etc/sysconfig/network-scripts/ifcfg-e*
# https://kb.vmware.com/s/article/88199
rm -fv /etc/NetworkManager/system-connections/e*.nmconnection
