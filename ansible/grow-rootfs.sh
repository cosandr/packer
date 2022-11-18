#!/bin/bash
set -euo pipefail

root_part="$(findmnt -nrv -o source /)"
root_disk="/dev/$(lsblk -nr -o pkname "$root_part")"
root_partno="$(grep -Eo '[0-9]+$' <<< "$root_part")"
root_type="$(findmnt -nrv -o fstype /)"

if ! fdisk -l "$root_disk" 2>&1 >/dev/null | grep -q 'size mismatch'; then
  echo "No mismatch detected"
  exit 0
fi

if [[ -z $root_partno ]]; then
  echo "Could not determine root partition number"
  exit 1
fi

echo "Found disk: $root_disk"
echo "Found partition: $root_part"
echo "Found partition number: $root_partno"

growpart "$root_disk" "$root_partno"

if [[ $root_type = ext4 ]]; then
  resize2fs "$root_part"
elif [[ $root_type = btrfs ]]; then
  btrfs filesystem resize max /
elif [[ $root_type = xfs ]]; then
  xfs_growfs /
else
  echo "$root_type: Unknown file system, cannot expand"
fi
systemctl disable grow-rootfs.service
