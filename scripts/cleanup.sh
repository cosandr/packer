#!/bin/bash

rm -rf /etc/ssh/ssh_host_*key* /root/* /var/spool/mail/*
rm -f $HISTFILE && unset HISTFILE
HISTSIZE=0

rm -rf /usr/share/backgrounds/*

yum -y install glibc-locale-source glibc-langpack-en
rm -f /usr/lib/locale/locale-archive
/usr/bin/localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 &> /dev/null

rpm --rebuilddb
yum clean all
rm -rf /var/cache/yum/*

cleanup=( /boot/zero /boot/efi/zero /zero )

for f in "${cleanup[@]}"; do
  dd if=/dev/zero of="$f" bs=1M
  rm -f "$f"
done

find /var/log -type f -delete
