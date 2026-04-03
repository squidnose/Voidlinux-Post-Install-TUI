#!/bin/bash
echo "For NVIDIA Maxwell cards and above (Geforce 900+)"

echo "Highly reccomended to remove unsed kernels."
echo "This will speed-up the install procces."
read -p "Do you want to remove unused kernels before installing the NVIDIA driver? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Searching and removing old unused kernels..."
    sudo vkpurge rm all
else
    echo "Skipping kernel removal."
fi


sudo xbps-install nvidia nvidia-libs-32bit nvidia-opencl nvidia-docker vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit nvidia-vaapi-driver
echo "NVIDIA Maxwell, Pascal, and Volta support is ending soon."
