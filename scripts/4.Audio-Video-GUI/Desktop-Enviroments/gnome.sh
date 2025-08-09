#!/bin/bash
echo "Installing Core apps"
sudo xbps-install -Syu xorg wayland gnome gnome-apps gnome-core gnome-software 
echo "Adding extras"
sudo xbps-install -Syu gnome-bluetooth gnome-online-accounts gnome-authenticator gnome-autoar gnome-browser-connector gnome-icon-theme gnome-icon-theme-extras 
echo "adding extensiones"
sudo xbps-install -Syu gnome-tweaks gnome-shell-extensions extension-manager nemo-extensions nautilus-gnome-terminal-extension nautilus-papers-extension
install -y flathub org.gnome.Extensions
