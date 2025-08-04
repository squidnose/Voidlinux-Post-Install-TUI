#!/bin/bash

echo "=================================================="
echo "        Transmission BitTorrent Client Script     "
echo "=================================================="
echo ""

echo "This script will install the Transmission BitTorrent client."
echo "Please choose your preferred toolkit version:"
echo "  1) Transmission-GTK (integrates well with GTK-based desktops like GNOME, XFCE, Cinnamon, MATE)"
echo "  2) Transmission-Qt (integrates well with Qt-based desktops like KDE Plasma, LXQt)"
echo ""

# Loop until a valid choice is made
while true; do
    read -rp "Enter your choice (1 or 2): " choice
    case "$choice" in
        1)
            INSTALL_VERSION="gtk"
            break
            ;;
        2)
            INSTALL_VERSION="qt"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

echo "" # Blank line for readability

# --- Execute Installation Based on Choice ---

if [ "$INSTALL_VERSION" == "gtk" ]; then
    echo "Attempting to install Transmission-GTK..."
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y transmission-gtk
        if [ $? -eq 0 ]; then
            echo "Transmission-GTK installation complete!"
        else
            echo "Error: Transmission-GTK installation failed."
            echo "Please check your internet connection or try updating XBPS repositories (sudo xbps-install -Sy)."
        fi
    else
        echo "Error: 'xbps-install' command not found. This should not happen on Void Linux."
        echo "Please verify your system's package manager setup."
    fi
elif [ "$INSTALL_VERSION" == "qt" ]; then
    echo "Attempting to install Transmission-Qt..."
    if command -v xbps-install &>/dev/null; then
        sudo xbps-install -y transmission-qt
        if [ $? -eq 0 ]; then
            echo "Transmission-Qt installation complete!"
        else
            echo "Error: Transmission-Qt installation failed."
            echo "Please check your internet connection or try updating XBPS repositories (sudo xbps-install -Sy)."
        fi
    else
        echo "Error: 'xbps-install' command not found. This should not happen on Void Linux."
        echo "Please verify your system's package manager setup."
    fi
fi

echo "" # Blank line for readability
echo "Transmission client script finished."

# Pause for user to see final messages before returning to main TUI
read -rp "Press Enter to return to the main menu."

exit 0
