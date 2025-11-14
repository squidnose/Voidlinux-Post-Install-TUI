#/bin/bash
echo "For NVIDIA Kepler cards (Geforce 600/700)"

echo "Highly reccomended to remove unsed kernels."
echo "This will speed-up the install procces."
read -p "Do you want to remove unused kernels before installing the NVIDIA driver? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Searching and removing old unused kernels..."
    sudo vkpurge rm all
else
    echo "Skipping kernel removal."
fi


sudo xbps-install nvidia470 nvidia470-libs-32bit nvidia470-opencl linux6.12 linux6.12-headers vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit nvidia-vaapi-driver
echo "Nvidia470 driver may have issues with kernels newer than 6.12."
echo "You must select linux 6.12 at startup."
echo "For GRUB Customizer configuration, I recommend the package: download in octoxbps or via sudo xbps-install grub-customizer"

