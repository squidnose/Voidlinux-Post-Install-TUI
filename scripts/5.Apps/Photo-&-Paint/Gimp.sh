#!/bin/bash
echo "This script will install GIMP"
echo "Please choose your preferred installation method:"
echo "  1)(Reccomended) Install via XBPS (system-integrated, Void Linux's native package manager)"
echo "  2) Install via Flatpak (sandboxed, often newer versions)"
echo ""

# Loop until a valid choice is made
while true; do
    read -rp "Enter your choice (1 or 2): " choice
    case "$choice" in
        1)
            INSTALL_METHOD="xbps"
            break
            ;;
        2)
            INSTALL_METHOD="flatpak"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

echo "" # Blank line for readability

# --- Execute Installation Based on Choice ---

if [ "$INSTALL_METHOD" == "flatpak" ]; then
    echo "Attempting to install via Flatpak..."
    if command -v flatpak &>/dev/null; then
        flatpak install --noninteractive flathub org.gimp.GIMP
        if [ $? -eq 0 ]; then
            echo "Installation complete!"
        else
            echo "Error: Installation failed."
            # Check if flathub remote exists; if not, suggest adding it
            if ! flatpak remotes | grep -q flathub &>/dev/null; then
                echo "It seems the 'flathub' remote might not be added."
                echo "You might need to add it: sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
                echo "Then try installing this again."
            fi
        fi
    else
        echo "Error: 'flatpak' command not found."
        echo "Please install Flatpak first (e.g., 'sudo xbps-install flatpak') and then try again."
    fi
elif [ "$INSTALL_METHOD" == "xbps" ]; then
    echo "Attempting to install via XBPS..."
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y gimp
        if [ $? -eq 0 ]; then
            echo "Installation complete!"
        else
            echo "Error: XBPS installation failed."
            echo "Please check your internet connection or try updating XBPS repositories (sudo xbps-install -Sy)."
        fi
    else
        echo "Error: 'xbps-install' command not found. This should not happen on Void Linux."
        echo "Please verify your system's package manager setup."
    fi
fi

exit 0
