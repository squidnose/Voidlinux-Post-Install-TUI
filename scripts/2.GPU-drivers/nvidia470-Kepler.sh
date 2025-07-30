#/bin/bash
echo "For NVIDIA Kepler cards and above (Geforce 600/700)"
#read -p "Press Enter to install, CTRL+c to cancel"

sudo xbps-install nvidia470 nvidia470-libs-32bit nvidia470-opencl linux6.12 linux6.12-headers vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit
echo "Nvidia470 driver may have issues with kernels newer than 6.12."
echo "You must select linux 6.12 at startup."
echo "For GRUB Customizer configuration, I recommend the package: download in octoxbps or via sudo xbps-install grub-customizer"

