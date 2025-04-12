#!/bin/bash
set -ueox pipefail

VBoxManage modifyvm "${DISTRO}" --clipboard-mode bidirectional
VBoxManage modifyvm "${DISTRO}" --natpf1 "ssh,tcp,,2222,,22"
