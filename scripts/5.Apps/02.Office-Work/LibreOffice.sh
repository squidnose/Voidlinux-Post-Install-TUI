#!/bin/bash

echo "=================================================="
echo "          LibreOffice Installation Script         "
echo "=================================================="
echo ""

echo "This script will install the base LibreOffice suite first."
echo "Then, you can choose a desktop environment integration for better visuals."
echo ""

echo "--- Installing base LibreOffice ---"
sudo xbps-install -y libreoffice

echo "LibreOffice base installation complete!"
echo ""

echo "Now, choose your desired desktop environment integration:"
echo "  1) KDE Plasma Integration (uses libreoffice-kde)"
echo "  2) GNOME Integration (uses libreoffice-gnome)"
echo "  3) XFCE/Cinnamon/MATE Integration (uses libreoffice-libgtk)"
echo "  4) LXQt Integration (uses libreoffice-qt6)"
echo "  5) No specific integration (use default, may not look native on your desktop)"
echo ""

# Loop until a valid choice is made
while true; do
    read -rp "Enter your choice (1, 2, 3, 4, or 5): " choice
    case "$choice" in
        1)
            INTEGRATION_PACKAGE="libreoffice-kde"
            INTEGRATION_NAME="KDE Plasma"
            break
            ;;
        2)
            INTEGRATION_PACKAGE="libreoffice-gnome"
            INTEGRATION_NAME="GNOME"
            break
            ;;
        3)
            INTEGRATION_PACKAGE="libreoffice-libgtk"
            INTEGRATION_NAME="XFCE/Cinnamon/MATE (GTK)"
            break
            ;;
        4)
            INTEGRATION_PACKAGE="libreoffice-qt6"
            INTEGRATION_NAME="LXQt (Qt6)"
            break
            ;;
        5)
            INTEGRATION_PACKAGE="" # No extra package
            INTEGRATION_NAME="None"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, 3, 4, or 5."
            ;;
    esac
done

echo "" # Blank line for readability

# --- Install Integration Package (if chosen) ---
if [ -n "$INTEGRATION_PACKAGE" ]; then # Check if INTEGRATION_PACKAGE is not empty
    echo "Attempting to install $INTEGRATION_NAME integration..."
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y "$INTEGRATION_PACKAGE" # Quote variable to handle spaces if multiple packages were specified (good practice)
        if [ $? -eq 0 ]; then
            echo "$INTEGRATION_NAME integration installed complete!"
        else
            echo "Error: $INTEGRATION_NAME integration installation failed."
            echo "You can try installing it manually later (e.g., 'sudo xbps-install -S $INTEGRATION_PACKAGE')."
        fi
    else
        echo "Error: 'xbps-install' command not found. This should not happen on Void Linux."
    fi
else
    echo "No specific desktop environment integration selected."
fi

echo ""
echo "Note for LibreOffice: You may want to install a language pack."
echo "For that, you can use OctoXBPS or run: sudo xbps-install -S libreoffice-i18n-<your_language_code>"
echo "Example for Czech: sudo xbps-install -S libreoffice-i18n-cs"

echo "" # Blank line for readability
echo "LibreOffice installation script finished."

# Pause for user to see final messages before returning to main TUI

exit 0
