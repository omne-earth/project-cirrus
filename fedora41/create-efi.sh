#!/bin/bash
set -ueox pipefail
PROJECT_DIR="$(dirname $(dirname $(realpath $0)))"
DISTRO="$(basename $(dirname $(realpath $0)))"
ISO_DIR="${PROJECT_DIR}/iso"
ISO_FILE="${ISO_DIR}/${DISTRO}/${DISTRO}.iso"
VM_DIR="${PROJECT_DIR}/vm"
VHD_FILE="${VM_DIR}/${DISTRO}/${DISTRO}-efi.vhd"

# Azure Gen2 support
# Azure NVME support
# Azure Premium storage support
# Login with Microsoft Entra ID

# re-create vm
rm -rf "${VM_DIR}/${DISTRO}"
VBoxManage unregistervm "${DISTRO}" --delete && true
VBoxManage createvm --name "${DISTRO}" --ostype "Fedora_64" --register --basefolder "${VM_DIR}"

# enable uefi and secure-boot
VBoxManage modifyvm "${DISTRO}" --firmware efi64
VBoxManage modifyvm "${DISTRO}" --tpm 2.0

# initialize uefi signatures
VBoxManage modifynvram "${DISTRO}" inituefivarstore
VBoxManage modifynvram "${DISTRO}" enrollmssignatures
VBoxManage modifynvram "${DISTRO}" enrollorclpk

# setup cpu and memory
VBoxManage modifyvm "${DISTRO}" --cpus 4
VBoxManage modifyvm "${DISTRO}" --nested-hw-virt on
VBoxManage modifyvm "${DISTRO}" --ioapic on
VBoxManage modifyvm "${DISTRO}" --memory 16384
VBoxManage modifyvm "${DISTRO}" --vram 128

# setup network
INTERFACE="$(nmcli -f GENERAL.DEVICE device show | grep 'wlp' | cut -d ':' -f 2 | tr -d '[:space:]')"
VBoxManage modifyvm "${DISTRO}" --nic1 bridged --bridgeadapter1 "${HOST_INTERFACE}"

# add a SCSI boot disk
VBoxManage createmedium --filename "${VHD_FILE}" --size 32768 --format VHD --variant FIXED
VBoxManage storagectl "${DISTRO}" --name "SCSI Controller" --add scsi --controller LSILogic --portcount 16 --bootable on
VBoxManage storageattach "${DISTRO}" --storagectl "SCSI Controller" --port 0 --device 0 --type hdd --medium "${VHD_FILE}" 

# add a IDE controller for bootable iso
VBoxManage storagectl fedora41 --name "IDE Controller" --remove && true
VBoxManage storagectl "${DISTRO}" --name "IDE Controller" --add ide --controller PIIX4 --portcount 2
VBoxManage storageattach "${DISTRO}" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "${ISO_FILE}"

# setup boot order
VBoxManage modifyvm "${DISTRO}" --boot1 dvd --boot2 disk --boot3 none --boot4 none

# start the vm
VBoxManage startvm "${DISTRO}" --type headless
