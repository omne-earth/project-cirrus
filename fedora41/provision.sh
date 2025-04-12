
# kickstart
# provision user
# enable ssh and rdp

echo 'add_drivers+=" hv_netvsc hv_storvsc hv_vmbus "' | sudo tee -a /etc/dracut.conf.d/hv.conf
sudo dracut -f -v
sudo lsinitrd | grep -i hv_


# VBoxHeadless --startvm "${DISTRO}"
# actionproject@vbox:~$ sudo grdctl --system rdp set-port 33890
# [sudo] password for actionproject: 
# Init TPM credentials failed because No TPM device found, using GKeyFile as fallback.
# actionproject@vbox:~$ sudo systemctl restart gnome-remote-desktop.service
# actionproject@vbox:~$ ss -lntl

# # Remote Login

sudo systemctl enable sshd.service
sudo grdctl --system rdp enable
sudo dnf install freerdp
sudo -u gnome-remote-desktop winpr-makecert -silent -rdp -path ~gnome-remote-desktop rdp-tls
sudo grdctl --system rdp set-tls-cert ~gnome-remote-desktop/rdp-tls.crt
sudo grdctl --system rdp set-tls-key ~gnome-remote-desktop/rdp-tls.key
sudo grdctl --system rdp disable-view-only
sudo grdctl --system rdp clear-credentials
sudo grdctl --system rdp set-credentials actionproject projectcirrus
sudo systemctl --now enable gnome-remote-desktop.service

sudo systemctl start sshd.service
sudo systemctl start gnome-remote-desktop.service

sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=rdp
sudo firewall-cmd --reload
