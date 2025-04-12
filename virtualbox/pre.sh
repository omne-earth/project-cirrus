#!/bin/bash
set -ueox pipefail

sudo usermod -aG vboxusers $USER
sudo mkdir -p /var/lib/shim-signed/mok
sudo openssl req -nodes -new -x509 -newkey rsa:2048 -outform DER -addext "extendedKeyUsage=codeSigning" \
    -keyout /var/lib/shim-signed/mok/MOK.priv \
    -out /var/lib/shim-signed/mok/MOK.der \
    -subj "/C=US/ST=California/L=Los Angeles/O=Action Project/CN=actionproject.net"
sudo mokutil --import /var/lib/shim-signed/mok/MOK.der

GRUB_CMDLINE_LINUX=$(cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX" | tee /dev/tty)
NEW_GRUB_CMDLINE_LINUX="${GRUB_CMDLINE_LINUX::-1} kvm.enable_virt_at_load=0\""
echo $NEW_GRUB_CMDLINE_LINUX
sudo sed -i "s/$GRUB_CMDLINE_LINUX/$NEW_GRUB_CMDLINE_LINUX/g" /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

sudo systemctl reboot
