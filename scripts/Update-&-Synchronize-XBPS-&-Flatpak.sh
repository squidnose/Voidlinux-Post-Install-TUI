#!/bin/bash
echo "Updating XBPS System Packages"
sudo xbps-install -Syu
sudo xbps-install -Syu xbps
sudo xbps-install -Syu

echo "Updating Flatpak Packages"
flatpak update
echo "Update-complete"
