#!/usr/bin/sudo bash

echo "enter sudo password to contine"
sudo echo "Continuing..."

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/nix-build.sh | sudo bash
sleep 1

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/nix-utils-install.sh | sudo bash
sleep 1

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/nix-link.sh | sudo bash -s $1
sleep 1

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/nix-service.sh | sudo bash
sleep 1

curl -s https://raw.githubusercontent.com/percygt/nix-installer-scripts/main/nix-out-of-default/build-scripts/configure.sh | sudo bash
sleep 1


