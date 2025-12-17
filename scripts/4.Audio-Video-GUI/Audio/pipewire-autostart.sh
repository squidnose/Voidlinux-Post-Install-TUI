#!/bin/bash
echo "this will add a .desktop file to make pipewire automaticly start for the logged in user that is running this script"
cat > ~/.config/autostart/wireplumber.desktop <<EOF
[Desktop Entry]
Exec=pipewire
Icon=
Name=pipewire
Path=
Terminal=False
Type=Application
EOF
echo "Done"
