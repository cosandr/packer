#!/bin/bash

set -euo pipefail

OPTIND=1

show_help() {
cat <<-END
Usage $0: [OPTIONS]

Options:
-h    Show this message
-l    Copy locally
-s    Symlink instead of rsyncing, implies local mode
-t    Target host, in <user>@<host> format
-n    Dry run
END
}

LOCAL=0
SYMLINK=0
TARGET=""
ARGS=""

while getopts "nhlst:" opt; do
  case "$opt" in
    h)
      show_help
      exit 0
      ;;
    l)
      LOCAL=1
      ;;
    s)
      LOCAL=1
      SYMLINK=1
      ;;
    t)
      TARGET="$OPTARG"
      ;;
    n)
      ARGS="-n"
      ;;
    *)
      show_help
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [[ -z $TARGET && $LOCAL -eq 0 ]]; then
  echo "Target is required if not in local mode"
  exit 1
fi

find "$(pwd -P)/artifacts" -type f -name '*.qcow2' -print0 | while read -r -d $'\0' file
do
  filename="$(basename "$file")"
  echo "Processing $filename"
  if [[ $SYMLINK -eq 1 ]]; then
    sudo ln -sfv $ARGS "$file" "/var/lib/libvirt/images/${filename}"
  elif [[ $LOCAL -eq 1 ]]; then
    sudo rsync -vh $ARGS --progress "$file" "/var/lib/libvirt/images/${filename}"
  else
    rsync -vh  $ARGS --progress "$file" "${TARGET}:/var/lib/libvirt/images/${filename}"
  fi
done

if [[ $LOCAL -eq 1 ]]; then
  virsh pool-refresh --pool default
else
  ssh "$TARGET" virsh pool-refresh --pool default
fi
