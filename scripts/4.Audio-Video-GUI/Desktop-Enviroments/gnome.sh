#!/bin/bash
sudo xbps-install -Syu xorg wayland gnome gnome-apps gnome-bluetooth gnome-online-accounts gnome-authenticator gnome-autoar gnome-browser-connector gnome-icon-theme gnome-icon-theme-extras gnome-tweaks gnome-core gnome-shell-extensions gnome-software
flatpak install -y flathub org.gnome.Extensions
