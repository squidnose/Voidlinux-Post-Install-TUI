#!/bin/bash
# Runs all script in this directory
## Acts like a non skipable wizard
BASE_DIR="$(dirname "$(realpath "$0")")"

echo "Running all app scripts..."

# 01 Terminal Utils
"$BASE_DIR/01.1-Terminal-Utils-XBPS.sh"

# 02 Internet
"$BASE_DIR/02.1-Internet-XBPS.sh"
"$BASE_DIR/02.2-Internet-Flatpak.sh"
"$BASE_DIR/02.3-Browser-Selection.sh"

# 03 Office
"$BASE_DIR/03.1-Office-XBPS.sh"
"$BASE_DIR/03.2-Office-Flatpak.sh"
"$BASE_DIR/03.3-LibreOffice-i18n.sh"
"$BASE_DIR/03.4-Non-Free-Fonts.sh"

# 04 Media + Photo
"$BASE_DIR/04.1-Media-XBPS.sh"
"$BASE_DIR/04.2-Media-FLATHUB.sh"
"$BASE_DIR/04.3-Photo-and-Paint-XBPS.sh"
"$BASE_DIR/04.4-Photo-and-Paint-FLATHUB.sh"

# 05 Phone Integration
"$BASE_DIR/05.1Phone-Integration-XBPS.sh"

# 06 Remote Connection
"$BASE_DIR/06.1Remote-Connection-XBPS.sh"
"$BASE_DIR/06.2Remote-Connection-Flatpak.sh"

# 07 Virtualization
"$BASE_DIR/07.1Virt-Manager.sh"
"$BASE_DIR/07.2VirtualBox.sh"
"$BASE_DIR/07.3Docker.sh"
"$BASE_DIR/07.4Waydroid.sh"
"$BASE_DIR/07.5Distrobox.sh"

# 08 Games
"$BASE_DIR/08.1Games-XBPS.sh"
"$BASE_DIR/08.2Games-FLATHUB.sh"
"$BASE_DIR/08.3steam.sh"

# 09 Software Config
"$BASE_DIR/09.1SW-Config-Info-XBPS.sh"
"$BASE_DIR/09.2SW-Config-Info-Flatpak.sh"
"$BASE_DIR/09.3Intel-RAPL-power-permission.sh"

# 10 Hardware Config
"$BASE_DIR/10.1HW-Config-Info-XBPS.sh"
"$BASE_DIR/10.2HW-Config-Info-FLatpak.sh"

# 11 Serial
"$BASE_DIR/11.1Serial-CommsXBPS.sh"

# 12 Non-Linux Apps
"$BASE_DIR/12.1Non-Linux-AppsXBPS.sh"
"$BASE_DIR/12.2Non-Linux-AppsFlatpak.sh"

# 13 Network Utilities
"$BASE_DIR/13.1Network-UtilitiesXBPS.sh"

# 14 Programming
"$BASE_DIR/14.1ProgramingXBPS.sh"
exit 0
