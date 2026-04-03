#!/bin/bash
set -e
#1. Text
echo "Nvidia-FIX-Brightness-Controll-Nvidia"
echo "Usefull for some Nvidia Laptops especially when Optimus is turnes off"
echo "This will add acpi_backlight=vendor as a parameter "
echo "You can disable this later in 0.Tools -> 4.Kernel-Parameter-Optimizations -> kernel-parameter-TUI-config.sh"
read -p "Press Enter to install, CTRL+c to cancel"

#2. Parameters
GRUB_FILE="/etc/default/grub"
PARAMETER="acpi_backlight=vendor"

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

echo "Brightness controll should work now!"
echo "Reboot your system now to apply changes."



