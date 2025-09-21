#!/bin/bash
set -e
echo "Forces to only use Nvidia GPU on laptop with hybrid graphics"
echo "Highly reccomended to Run Nvidia-DRM-modeset.sh aswell."
echo "This will make a /etc/X11/xorg.conf.d/10-nvidia.conf file"
read -p "Press Enter to install, CTRL+c to cancel"
echo "Detecting NVIDIA BusID..."
NVIDIA_BUS_ID=$(lspci | grep -i "VGA.*NVIDIA" | awk '{print $1}' | sed 's/:/ /g' | awk '{ printf("PCI:%s:%s:%s", strtonum("0x" $1), $2, $3) }')

echo "Creating /etc/X11/xorg.conf.d/10-nvidia.conf..."
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
