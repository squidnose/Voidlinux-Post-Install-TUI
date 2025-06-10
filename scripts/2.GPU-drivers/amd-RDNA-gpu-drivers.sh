#/bin/bash
echo "For AMD RDNA cards and above. AMDVLK Vulkan (RX 5000+)"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode amdvlk amdvlk-32bit xf86-video-amdgpu vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools radeontop libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit

