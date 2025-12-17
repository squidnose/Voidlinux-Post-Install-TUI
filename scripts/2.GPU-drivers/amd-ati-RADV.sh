#!/bin/bash
echo "For all AMD and ATI cards Terrascale, GCN, RDNA, UDNA. (ATI HD 2000 and up)"
echo "RADV Vulkan driver for GCN+ (Radeon HD 7000+)"
#read -p "Press Enter to install, CTRL+c to cancel"
echo "Installing 2D Xorg accelaration packages"
sudo xbps-install -Sy xf86-video-amdgpu xf86-video-ati

echo "Installing 3D accelaration packages"
sudo xbps-install -Sy mesa-dri mesa-opencl gamemode ocl-icd mesa-vulkan-radeon vulkan-loader Vulkan-Headers Vulkan-Tools
echo "Installing Video accelaration packages"
sudo xbps-install -Sy mesa-vaapi mesa-vdpau libspa-vulkan libva

echo "Installing 32bit 3D accelaration packages, Will fail on Musl"
sudo xbps-install -Sy mesa-dri-32bit mesa-opencl-32bit libgamemode-32bit ocl-icd-32bit mesa-vulkan-radeon-32bit vulkan-loader-32bit
echo "Installing 32bit Video accelaration packages, Will fail on Musl"
sudo xbps-install -Sy mesa-vaapi-32bit mesa-vdpau-32bit libspa-vulkan-32bit libva-32bit

echo "Installing Radeontop, usefull for finding info about GPU. Similar to nvidia-smi"
sudo xbps-install -Sy radeontop

echo "To use AMDGPU driver on older GCN 1 and 2, run this script:"
echo "amd-Switch-to-AmdGPU-GCN1.sh"
