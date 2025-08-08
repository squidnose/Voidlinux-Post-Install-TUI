#!/bin/bash
TERMINAL=$(command -v xdg-terminal || command -v x-terminal-emulator || echo konsole)

"$TERMINAL" -e bash -c '
echo "Go to Fullscreen and Please Enter Your Password:"
sudo xbps-install -Syu xbps &&
sudo xbps-install -Syu git dialog newt &&
rm -rf Voidlinux-Post-Install-TUI &&
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git &&
cd Voidlinux-Post-Install-TUI &&
chmod +x Void-post-install-script.sh &&
./Void-post-install-script.sh
'
