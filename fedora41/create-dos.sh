#!/bin/bash
set -ueox pipefail
PROJECT_DIR="$(dirname $(dirname $(realpath $0)))"
DISTRO="$(basename $(dirname $(realpath $0)))"
ISO_DIR="${PROJECT_DIR}/iso"
ISO_FILE="${ISO_DIR}/${DISTRO}/${DISTRO}.iso"
VM_DIR="${PROJECT_DIR}/vm"
VHD_FILE="${VM_DIR}/${DISTRO}/${DISTRO}.vhd"

# re-create vm
rm -rf "${VM_DIR}/${DISTRO}"
VBoxManage unregistervm "${DISTRO}" --delete && true
VBoxManage createvm --name "${DISTRO}" --ostype "Fedora_64" --register --basefolder "${VM_DIR}"

# setup cpu and memory
VBoxManage modifyvm "${DISTRO}" --cpus 4
VBoxManage modifyvm "${DISTRO}" --ioapic on
VBoxManage modifyvm "${DISTRO}" --memory 16384
VBoxManage modifyvm "${DISTRO}" --vram 128

# setup network
VBoxManage modifyvm "${DISTRO}" --nic1 nat

# add sata disk
# create as raw
# VBoxManage createmedium --filename "${VHD_FILE}" --size 16384 --format VHD --variant FIXED 
VBoxManage storagectl "${DISTRO}" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "${DISTRO}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VHD_FILE}" 

# add a IDE controller for bootable iso
VBoxManage storagectl fedora41 --name "IDE Controller" --remove && true
VBoxManage storagectl "${DISTRO}" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "${DISTRO}" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "${ISO_FILE}"

# setup boot order
VBoxManage modifyvm "${DISTRO}" --boot1 dvd --boot2 disk --boot3 none --boot4 none
