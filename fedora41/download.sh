#!/bin/bash
set -ueox pipefail
PROJECT_DIR="$(dirname $(dirname $(realpath $0)))"
ISO_DIR="${PROJECT_DIR}/iso"
DISTRO="$(basename $(dirname $(realpath $0)))"
DISTRO_ISO_DIR="${ISO_DIR}/${DISTRO}"
mkdir -p "${DISTRO_ISO_DIR}"
cd "${DISTRO_ISO_DIR}"
curl -LO https://download.fedoraproject.org/pub/fedora/linux/releases/41/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-41-1.4.iso
curl -LO https://download.fedoraproject.org/pub/fedora/linux/releases/41/Workstation/x86_64/iso/Fedora-Workstation-41-1.4-x86_64-CHECKSUM
curl -LO https://fedoraproject.org/fedora.gpg
gpgv --keyring ./fedora.gpg Fedora-Workstation-41-1.4-x86_64-CHECKSUM
sha256sum --ignore-missing -c Fedora-Workstation-41-1.4-x86_64-CHECKSUM
mv Fedora-Workstation-Live-x86_64-41-1.4.iso fedora41.iso
ln -s ./Fedora-Workstation-Live-x86_64-41-1.4.iso ./fedora41.iso
