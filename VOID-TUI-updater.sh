#!/bin/bash
set -e

# Update system and install dependencies
echo "Enter Password:"
sudo xbps-install -Syu xbps
sudo xbps-install -Sy git dialog newt

# Repo info
APP_DIR="$HOME/Voidlinux-Post-Install-TUI"
REPO_URL="https://github.com/squidnose/Voidlinux-Post-Install-TUI"

# Function to check network
network_available() {
    ping -c 1 github.com &>/dev/null
}

if [ -d "$APP_DIR/.git" ]; then
    echo "Found existing TUI install."
    if network_available; then
        echo "Network detected, attempting to update..."
        cd
        rm -rf $APP_DIR
        git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git
    else
        echo "No network detected, using offline version."
    fi
else
    echo "No local copy found."
    if network_available; then
        echo "Cloning TUI from GitHub..."
        cd
        rm -rf $APP_DIR
        git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git
    else
        echo "No network and no local copy available. Cannot proceed."
        exit 1
    fi
fi

# Run the TUI
cd "$APP_DIR"
chmod +x VOID-TUI.sh
./VOID-TUI.sh
