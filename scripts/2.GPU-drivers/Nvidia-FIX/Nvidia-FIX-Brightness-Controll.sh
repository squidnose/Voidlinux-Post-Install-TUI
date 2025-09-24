#!/bin/bash
set -e
echo "Nvidia-FIX-Brightness-Controll-Nvidia"
echo "Usefull for some Nvidia Laptops especially when Optimus is turnes off"
echo "This will add acpi_backlight=vendor as a parameter "
echo "You can disable this later in 0.Tools -> 4.Kernel-Parameter-Optimizations -> kernel-parameter-TUI-config.sh"
read -p "Press Enter to install, CTRL+c to cancel"
# 1. Add kernel parameter
echo "Adding 'acpi_backlight=vendor' to GRUB_CMDLINE_LINUX..."
GRUB_FILE="/etc/default/grub"

if grep -q "acpi_backlight=vendor" "$GRUB_FILE"; then
    echo "Kernel parameter already present."
else
    sudo sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="acpi_backlight=vendor /' "$GRUB_FILE"
    echo "Parameter added. Regenerating GRUB config..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Brightness controll should work now!"
echo "Reboot your system now to apply changes."
