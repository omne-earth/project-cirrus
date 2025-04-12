#!/bin/bash
set -ueox pipefail

curl -O https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo rpm --import oracle_vbox_2016.asc
rm oracle_vbox_2016.asc

curl -LO https://download.virtualbox.org/virtualbox/7.1.6/VirtualBox-7.1-7.1.6_167084_fedora40-1.x86_64.rpm
sudo dnf install -y VirtualBox-7.1-7.1.6_167084_fedora40-1.x86_64.rpm
rm VirtualBox-7.1-7.1.6_167084_fedora40-1.x86_64.rpm
