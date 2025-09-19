#/bin/bash
echo "For NVIDIA Fermi cards (Geforce 400/500)"

echo "Highly reccomended to remove unsed kernels."
echo "This will speed-up the install procces."
read -p "Do you want to remove unused kernels before installing the NVIDIA driver? (y/n): " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Searching and removing old unused kernels..."
    sudo vkpurge rm all
else
    echo "Skipping kernel removal."
fi

sudo xbps-install nvidia390 nvidia390-libs-32bit nvidia390-opencl linux6.1 linux6.1-headers ocl-icd ocl-icd-32bit
echo "Nvidia390 driver may have issues with kernels newer than 6.6."
echo "You must select linux 6.1 at startup."
echo "For GRUB Customizer configuration, I recommend the package: download in octoxbps or via sudo xbps-install grub-customizer"

