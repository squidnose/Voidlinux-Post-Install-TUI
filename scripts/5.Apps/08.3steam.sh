#!/bin/bash

#============================ Term Size ============================
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
HEIGHT="$TERM_HEIGHT"
WIDTH="$TERM_WIDTH"
MENU_HEIGHT=$((HEIGHT - 10))
### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu

#============================ Steam Install Selection ============================

CHOICE=$(whiptail --title "Steam Installer" --menu \
"This script will install Steam\n\nChoose installation method:" "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
"1" "(For Glibc) Install via XBPS (native, faster)" \
"2" "(For MUSL) Install via Flatpak (sandboxed, newer)" \
"0" "Exit" \
3>&1 1>&2 2>&3)

# If user presses ESC / Cancel
if [ $? -ne 0 ]; then
    exit 0
fi

#============================ Handle Choice ============================
case "$CHOICE" in
    1)
        INSTALL_METHOD="xbps"
        ;;
    2)
        INSTALL_METHOD="flatpak"
        ;;
    0)
        exit 0
        ;;
    *)
        whiptail --msgbox "Invalid choice." "$HEIGHT" "$WIDTH"
        exit 1
        ;;
esac

echo "" # Blank line for readability

# --- Execute Installation Based on Choice ---

if [ "$INSTALL_METHOD" == "flatpak" ]; then
    echo "Attempting to install via Flatpak..."
    if command -v flatpak &>/dev/null; then
        flatpak install --noninteractive flathub com.valvesoftware.Steam com.github.Matoking.protontricks
        sudo xbps-install -Syu steam-udev-rules
        whiptail --msgbox "You may need to add more permissions to steam flatpak" "$HEIGHT" "$WIDTH"
        if [ $? -eq 0 ]; then
            echo "Installation complete!"
        else
            echo "Error: Installation failed."
            # Check if flathub remote exists; if not, suggest adding it
            if ! flatpak remotes | grep -q flathub &>/dev/null; then
                whiptail --msgbox \
                "It seems the 'flathub' remote might not be added.
                You might need to add it:
                sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                Then try running this again." "$HEIGHT" "$WIDTH"
                exit 0
            fi
        fi
    else
        whiptail --msgbox "Error: 'flatpak' command not found." "$HEIGHT" "$WIDTH"
        whiptail --msgbox "Please install Flatpak first (e.g., 'sudo xbps-install flatpak') and then try again." "$HEIGHT" "$WIDTH"
    fi
elif [ "$INSTALL_METHOD" == "xbps" ]; then
    sudo xbps-install -y steam steamos-compositor protontricks
    if [ $? -eq 0 ]; then
        whiptail --msgbox "Steam XBPS Installation complete!" "$HEIGHT" "$WIDTH"
    else
        whiptail --msgbox "Error: XBPS installation failed." "$HEIGHT" "$WIDTH"
    fi
fi

exit 0
