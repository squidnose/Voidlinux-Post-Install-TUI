#!/bin/bash

set -e

echo "NVIDIA-Only Hybrid Setup for Plasma Wayland"

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

# 4. Create /etc/X11/xorg.conf.d/10-nvidia.conf
echo "🧠 Detecting NVIDIA BusID..."
NVIDIA_BUS_ID=$(lspci | grep -i "VGA.*NVIDIA" | awk '{print $1}' | sed 's/:/ /g' | awk '{ printf("PCI:%s:%s:%s", strtonum("0x" $1), $2, $3) }')

echo "📝 Creating /etc/X11/xorg.conf.d/10-nvidia.conf..."
sudo mkdir -p /etc/X11/xorg.conf.d/
cat <<EOF | sudo tee /etc/X11/xorg.conf.d/10-nvidia.conf > /dev/null
Section "Device"
    Identifier "Nvidia Card"
    Driver "nvidia"
    VendorName "NVIDIA Corporation"
    BusID "$NVIDIA_BUS_ID"
    Option "AllowEmptyInitialConfiguration"
EndSection
EOF

echo " NVIDIA-only hybrid mode is set up!"

echo "Reboot your system now to apply changes."
