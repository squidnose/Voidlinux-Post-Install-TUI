#/bin/bash
echo "For NVIDIA cards (Any)"
echo "These are FOSS alternatives to NVIDIA drivers."
echo "These drivers don't provide the best gaming performance but offer good support for cards no longer supported by NVIDIA."
echo "Recommended for NVIDIA Curie and Tesla (Geforce 6000, 7000 | Geforce 8000, 9000)"
#read -p "Press Enter to install, CTRL+c to cancel"

sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode xf86-video-nouveau ocl-icd ocl-icd-32bit vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit
