#!/bin/bash

echo "Preparing to install nix..."

sleep 5

sudo xbps-install -Sy wget
sudo xbps-install -Sy nix

echo "linking services"

sleep 1

sudo ln -s /etc/sv/nix-daemon /var/service/

sudo source /etc/profile

echo "Creating links..."
sudo ln -s /nix/var/nix/profiles/default /nix/nix-profile
sudo ln -s /nix/var/nix/profiles/default /var/nix-profile

"setting up configs..."

bash <(curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/backup-scripts/create-backup.sh)

sleep 5

bash <(curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-scripts/nix-sudo-path.sh)

echo "Modifying configurations"

sleep 1

sudo rm -f /etc/nix/nix.conf ; sudo wget -P /etc/nix https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-files/nix.conf
sudo rm -f /etc/profile.d/nix-app-icons.sh ; sudo wget -P /etc/profile.d https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-files/nix-app-icons.sh

sleep 1

echo "Installation has finnished"
