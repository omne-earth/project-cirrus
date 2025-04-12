#!/bin/bash
set -ueox pipefail

curl -sSL -O https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
sudo rpm -i packages-microsoft-prod.rpm && true
rm packages-microsoft-prod.rpm
sudo dnf update
sudo dnf install powershell -y
pwsh -c "Install-Module -Name Az -Repository PSGallery -Force"
pwsh -c "Update-Module -Name Az -Force"
