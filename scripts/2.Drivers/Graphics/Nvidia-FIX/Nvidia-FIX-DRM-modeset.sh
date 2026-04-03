#!/bin/bash
set -e
#1. text
echo "Nvidia DRM modeset"
echo "Useful for Wayland and KDE Plasma"
echo "This will add nvidia-drm.modeset=1 as a kernel parameter."
echo "You can disable this later in 0.Tools -> 4.Kernel-Parameter-Optimizations -> kernel-parameter-TUI-config.sh"
read -p "Press Enter to install, CTRL+c to cancel"

#2. Parameters
GRUB_FILE="/etc/default/grub"
PARAMETER="nvidia-drm.modeset=1"

echo "Adding '$PARAMETER' to GRUB_CMDLINE_LINUX_DEFAULT..."

#4. check if kernel parameter exists
if grep -q "$PARAMETER" "$GRUB_FILE"; then
    echo "Kernel parameter already present."
else
    # Extract the current parameters
    CURRENT_PARAMS=$(grep ^GRUB_CMDLINE_LINUX_DEFAULT= "$GRUB_FILE" | sed -E 's/^GRUB_CMDLINE_LINUX_DEFAULT="(.*)"/\1/')

    # Append the new one
    NEW_PARAMS="$CURRENT_PARAMS $PARAMETER"

    # Update the line safely
    sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\".*\"|GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_PARAMS\"|" "$GRUB_FILE"

    echo "Parameter added. Regenerating GRUB config..."
    sudo update-grub
fi

echo "Nvidia DRM modeset is set up!"
echo "Reboot your system now to apply changes."
