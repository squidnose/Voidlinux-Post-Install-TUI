#/bin/bash
echo "For Intel cards Gen 5 and above (Intel HD 2000+)"
echo "May have issues with Intel Gen 1-4 (GMA and similar). Solution is mesa-amber (Archlinux) or Debian Linux."
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode mesa-vulkan-intel mesa-vulkan-intel-32bit intel-video-accel xf86-video-intel vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit

