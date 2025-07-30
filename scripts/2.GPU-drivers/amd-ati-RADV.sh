#/bin/bash
echo "For all AMD and ATI cards Terrascale, GCN, RDNA, UDNA. (ATI HD 2000 and up)"
echo "RADV Vulkan driver for GCN+ (Radeon HD 7000+)"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode mesa-vulkan-radeon mesa-vulkan-radeon-32bit xf86-video-amdgpu xf86-video-ati vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools radeontop libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit
echo "To use AMDGPU driver on older GCN 1 and 2, run this script:"
echo "Switch-to-AmdGPU-GCN1.sh"
