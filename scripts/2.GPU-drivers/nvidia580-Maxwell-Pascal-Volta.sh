#/bin/bash
echo "For NVIDIA Maxwell, Pascal and Volta cards (Geforce 900/1000)"
echo "At the time of of writing, Nvidia580 is not a Package."
read -p "Press Enter to install, CTRL+c to cancel"

echo "Highly reccomended to remove unsed kernels."
echo "This will speed-up the install procces."
read -p "Do you want to remove unused kernels before installing the NVIDIA driver? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Searching and removing old unused kernels..."
    sudo vkpurge rm all
else
    echo "Skipping kernel removal."
fi

sudo xbps-install nvidia580 nvidia580-libs-32bit nvidia580-opencl vulkan-loader vulkan-loader-32bit Vulkan-Headers Vulkan-Tools libspa-vulkan libspa-vulkan-32bit ocl-icd ocl-icd-32bit nvidia-vaapi-driver

echo "if you are using this before Voidlinux has nvidia580 package, run nvidia-New-Stable.sh"
