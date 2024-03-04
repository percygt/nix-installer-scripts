#!/bin/bash

if [ ! -d "/nix" ] 
then
    echo "/nix cannot be created. Run \"sudo transactional-update run mksubvolume /nix\" to create /nix."
    exit 30
fi

sudo sleep 1

echo "Adding selinux content to /nix"

sleep 2

sudo semanage fcontext -a -t etc_t '/nix/store/[^/]+/etc(/.*)?' ; sudo semanage fcontext -a -t lib_t '/nix/store/[^/]+/lib(/.*)?' ; sudo semanage fcontext -a -t systemd_unit_file_t '/nix/store/[^/]+/lib/systemd/system(/.*)?' ; sudo semanage fcontext -a -t man_t '/nix/store/[^/]+/man(/.*)?' ; sudo semanage fcontext -a -t bin_t '/nix/store/[^/]+/s?bin(/.*)?' ; sudo semanage fcontext -a -t usr_t '/nix/store/[^/]+/share(/.*)?' ; sudo semanage fcontext -a -t var_run_t '/nix/var/nix/daemon-socket(/.*)?' ; sudo semanage fcontext -a -t usr_t '/nix/var/nix/profiles(/per-user/[^/]+)?/[^/]+'



echo "making SSL Certs"

sleep 3

sudo mkdir -p /etc/systemd/system/nix-daemon.service.d

sudo tee /etc/systemd/system/nix-daemon.service.d/override.conf <<EOF
[Service]
Environment="NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
EOF

echo "Preparing the nix install script"

sleep 5

sh <(curl -L https://nixos.org/nix/install) --daemon --yes

echo "Nix installer has Finished running"
sleep 1
echo "Now copying service files"

sleep 1

sudo rm -f /etc/systemd/system/nix-daemon.{service,socket} ; sudo cp /nix/var/nix/profiles/default/lib/systemd/system/nix-daemon.{service,socket} /etc/systemd/system/ ; sudo restorecon -RF /nix ; sudo systemctl daemon-reload ; sudo systemctl enable --now nix-daemon.socket

sleep 1

echo "Now setting SELinux back to Enforcing"

sudo setenforce Enforcing

sleep 1

echo "Copying SSL Cert files"

sleep 1

sudo cp /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-bundle.crt

sleep 1

bash <(curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-scripts/nix-sudo-path.sh)

echo "Modifying configurations"

sleep 1

sudo rm -f /etc/nix/nix.conf ; sudo wget -P /etc/nix https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-files/nix.conf
sudo rm -f /etc/profile.d/nix-app-icons.sh ; sudo wget -P /etc/profile.d https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/other-files/nix-app-icons.sh

echo "Building nix package manager..."

sleep 1

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/setup-nolink.sh | bash
curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/nix-link.sh | sudo transactional-update run bash -s /usr

echo "Cleaning up..."

sudo nix profile remove 0
sudo nix profile remove 0

echo "Linking..."

sleep 1

sudo ln -s /nix/var/nix/profiles/default /nix/nix-profile
sudo ln -s /nix/var/nix/profiles/default /var/nix-profile

echo "Making a nix backup"

sleep 1

bash <(curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/backup-scripts/create-backup-selinux.sh)

sleep 1

echo "Installation has finnished, you must reboot for this installation to work."
