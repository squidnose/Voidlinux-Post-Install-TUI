#!/bin/bash
#update xbps and check for dependencies has the added bonus of not asking user for password later
echo "Enter Password:"
sudo xbps-install -Syu xbps &&
sudo xbps-install -Sy git dialog newt
set -e
# Where the repo lives locally
APP_DIR="$HOME/Voidlinux-Post-Install-TUI"
REPO_URL="https://github.com/squidnose/Voidlinux-Post-Install-TUI"

# Try to update or clone
if [ -d "$APP_DIR/.git" ]; then
    echo "Found existing TUI install, attempting to update..."
    if git -C "$APP_DIR" pull --ff-only; then
        echo "Updated TUI."
    else
        echo "Could not update (network issue or divergence)."
        echo "Using offline version in $APP_DIR."
    fi
else
    echo "No local copy found, attempting initial clone..."
    if git clone "$REPO_URL" "$APP_DIR"; then
        echo "Cloned TUI."
    else
        echo "Could not clone (no network?)."
        echo "Offline version not available."
        exit 1
    fi
fi

# Now run the TUI from the local folder

cd $APP_DIR
chmod +x VOID-TUI.sh
./VOID-TUI.sh
