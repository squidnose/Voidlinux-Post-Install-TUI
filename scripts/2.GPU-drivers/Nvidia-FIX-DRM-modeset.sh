#!/bin/bash
set -e
echo "Nvidia DRM modeset"
echo "Usefull for Wayland and KDE plasma"
echo "This will add nvidia-drm.modeset=1 as a parameter "
read -p "Press Enter to install, CTRL+c to cancel"
# 1. Add kernel parameter
echo "Adding 'nvidia-drm.modeset=1' to GRUB_CMDLINE_LINUX..."
GRUB_FILE="/etc/default/grub"

if grep -q "nvidia-drm.modeset=1" "$GRUB_FILE"; then
    echo "✅ Kernel parameter already present."
else
    sudo sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1 /' "$GRUB_FILE"
    echo "✅ Parameter added. Regenerating GRUB config..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# 2. Create /etc/modprobe.d/nvidia.conf
echo "📄 Creating /etc/modprobe.d/nvidia.conf..."
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

# 3. Regenerate initramfs
echo "🔁 Regenerating initramfs with dracut..."
KERNEL_VERSION=$(uname -r)
sudo dracut --force /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION


echo "Nvidia DRM modeset is set up!"
echo "Reboot your system now to apply changes."
