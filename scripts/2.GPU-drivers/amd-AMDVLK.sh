#/bin/bash
echo "For AMD RDNA cards and above. (RX 5000+)"
echo "AMDVLK Vulkan driver"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode amdvlk amdvlk-32bit xf86-video-amdgpu xf86-video-ati vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools radeontop libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit

