#!/bin/bash
xfce4-terminal --fullscreen --hold --command "bash -c '
sudo xbps-install -Syu xbps &&
sudo xbps-install -Sy git dialog newt &&
rm -rf Voidlinux-Post-Install-TUI &&
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git &&
cd Voidlinux-Post-Install-TUI &&
chmod +x Void-post-install-script.sh &&
./Void-post-install-script.sh
'"
