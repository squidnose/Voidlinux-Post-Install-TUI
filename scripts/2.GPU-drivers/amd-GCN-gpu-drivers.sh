#/bin/bash
echo "For AMD GCN cards and above. RADV Vulkan (Radeon HD 7000+)"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode mesa-vulkan-radeon mesa-vulkan-radeon-32bit xf86-video-amdgpu vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools radeontop libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit
echo "To use AMDGPU driver on older GCN 1 and 2, add this to grub kernel parameters:"
echo "amdgpu.si_support=1 radeon.si_support=0"
