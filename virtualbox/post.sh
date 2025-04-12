#!/bin/bash
set -ueox pipefail

curl -LO https://download.virtualbox.org/virtualbox/7.1.6/Oracle_VirtualBox_Extension_Pack-7.1.6.vbox-extpack
vboxmanage extpack install Oracle_VirtualBox_Extension_Pack-7.1.6.vbox-extpack
rm Oracle_VirtualBox_Extension_Pack-7.1.6.vbox-extpack
