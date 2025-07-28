#!/bin/bash
konsole --fullscreen -e bash -c '
cd /tmp &&
rm -rf Voidlinux-Post-Install-TUI &&
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git &&
cd Voidlinux-Post-Install-TUI &&
chmod +x Void-post-install-script.sh &&
./Void-post-install-script.sh
'
