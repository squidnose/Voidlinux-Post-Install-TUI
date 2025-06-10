#/bin/bash
echo "For NVIDIA Maxwell cards and above (Geforce 900+)"
#read -p "Press Enter to install, CTRL+c to cancel"

sudo xbps-install nvidia nvidia-libs-32bit nvidia-opencl nvidia-docker vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit
echo "NVIDIA Maxwell, Pascal, and Volta support is ending soon. Find the latest version for these cards."
