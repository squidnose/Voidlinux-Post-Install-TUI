#!/bin/bash
# Whiptail-based Web Browser Installation Script

TITLE="Web Browser Installer"
BROWSERS=(
    "Firefox"
    "Vivaldi"
    "Chromium"
    "Falkon"
    "Lynx (Text-based)"
    "Google Chrome (Flatpak)"
    "Brave Browser (Flatpak)"
    "LibreWolf (Flatpak)"
    "Microsoft Edge (Flatpak)"
    "Mullvad Browser (Flatpak)"
    "Waterfox (Flatpak)"
    "Zen Browser (Flatpak)"
    "Tor Browser (Flatpak)"
)

declare -A INSTALL_COMMANDS=(
    ["Firefox"]="sudo xbps-install -Sy firefox"
    ["Vivaldi"]="sudo xbps-install -Sy vivaldi"
    ["Chromium"]="sudo xbps-install -Sy chromium chromium-widevine"
    ["Falkon"]="sudo xbps-install -Sy falkon"
    ["Lynx (Text-based)"]="sudo xbps-install -Sy lynx"
    ["Google Chrome (Flatpak)"]="flatpak install -y flathub com.google.Chrome"
    ["Brave Browser (Flatpak)"]="flatpak install -y flathub com.brave.Browser"
    ["LibreWolf (Flatpak)"]="flatpak install -y flathub io.gitlab.librewolf-community"
    ["Microsoft Edge (Flatpak)"]="flatpak install -y flathub com.microsoft.Edge"
    ["Mullvad Browser (Flatpak)"]="flatpak install -y flathub net.mullvad.MullvadBrowser"
    ["Waterfox (Flatpak)"]="flatpak install -y flathub net.waterfox.waterfox"
    ["Zen Browser (Flatpak)"]="flatpak install -y flathub app.zen_browser.zen"
    ["Tor Browser (Flatpak)"]="flatpak install -y flathub org.torproject.torbrowser-launcher"
)

# --- Build whiptail radiolist items ---
MENU_ITEMS=()
for browser in "${BROWSERS[@]}"; do
    MENU_ITEMS+=("$browser" "" OFF)
done

CHOICE=$(whiptail --title "$TITLE" \
    --radiolist "Select a web browser to install (Tab to move, Space to select, Enter to confirm):" \
    22 78 12 \
    "${MENU_ITEMS[@]}" \
    3>&1 1>&2 2>&3)

# Cancel pressed?
if [ $? -ne 0 ]; then
    whiptail --msgbox "Browser installation cancelled." 8 50
    exit 0
fi

install_command="${INSTALL_COMMANDS[$CHOICE]}"

# --- Validate dependencies before running ---
if [[ "$install_command" == flatpak* ]]; then
    if ! command -v flatpak &>/dev/null; then
        whiptail --msgbox "Error: Flatpak is not installed.\nRun: sudo xbps-install flatpak" 10 60
        exit 1
    fi
    if ! flatpak remotes | grep -q flathub; then
        whiptail --msgbox "Flathub remote is missing.\nRun:\n  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" 12 70
        exit 1
    fi
elif [[ "$install_command" == sudo\ xbps-install* ]]; then
    if ! command -v xbps-install &>/dev/null; then
        whiptail --msgbox "Error: xbps-install not found (unexpected on Void Linux)." 10 60
        exit 1
    fi
fi

# --- Run install ---
whiptail --msgbox "Installing: $CHOICE\n\nCommand:\n$install_command" 12 70
eval "$install_command"

if [ $? -eq 0 ]; then
    msg="$CHOICE installation complete!"
    if [ "$CHOICE" == "Firefox" ]; then
        if whiptail --title "Firefox Language Pack" --yesno "Install All Firefox Language packs?\nThis will take up more space\nYou can skip this and install firefox-i18n packs manually\neg: sudo xbps-install -Sy firefox-i18n-cs" 10 60; 
        then 
            sudo xbps-install -Sy firefox-i18n
        fi
    fi
    whiptail --msgbox "$msg" 15 70
else
    whiptail --msgbox "❌ Error: $CHOICE installation failed.\nCheck your internet connection and repos." 12 70
fi

exit 0
