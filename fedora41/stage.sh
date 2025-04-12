#!/bin/bash
set -ueox pipefail
PROJECT_DIR="$(dirname $(dirname $(realpath $0)))"
DISTRO="$(basename $(dirname $(realpath $0)))"
VHD_FILE="${PROJECT_DIR}/vm/${DISTRO}/${DISTRO}.vhd"
RAW_FILE="${PROJECT_DIR}/vm/${DISTRO}/${DISTRO}.raw"
TRUNK=$((1024*1024))

cp --force "${VHD_FILE}" "${VHD_FILE}.bak"
sudo qemu-img convert -f vpc -O raw "${VHD_FILE}" "${RAW_FILE}"
SIZES=$(qemu-img info -f raw --output json "${RAW_FILE}" | gawk 'match($0, /"virtual-size": ([0-9]+),/, val) {print val[1]}')
SIZE=$(echo $SIZES | cut -d ' ' -f 1)
ROUNDED_SIZE=$(((($SIZE+$TRUNK-1)/$TRUNK)*$TRUNK))

sudo qemu-img resize -f raw "${RAW_FILE}" "${ROUNDED_SIZE}"
sudo qemu-img convert -f raw -o "subformat=fixed,force_size" -O vpc "${RAW_FILE}" "${VHD_FILE}"
sudo rm --force "${RAW_FILE}"
sudo rm --force "${VHD_FILE}.bak"
