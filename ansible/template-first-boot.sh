#!/bin/bash

set -euo pipefail

if command -v dpkg-reconfigure &>/dev/null && [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    dpkg-reconfigure openssh-server
fi

if [ ! -f /etc/machine-id ]; then
    command -v dbus-uuidgen &>/dev/null && dbus-uuidgen --ensure
    systemd-machine-id-setup

    systemctl is-enabled systemd-networkd &>/dev/null && systemctl restart systemd-networkd
    systemctl is-enabled NetworkManager &>/dev/null && systemctl restart NetworkManager
    systemctl --failed | grep -q dbus && systemctl restart dbus
fi

systemctl disable template-first-boot.service
