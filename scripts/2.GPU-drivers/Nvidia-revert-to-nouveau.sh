#!/bin/bash
echo "This script will remove the nvidia Propriatery driver from your system"
read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-remove -y nvidia340 nvidia340-dkms nvidia340-libs nvidia340-libs-32bit nvidia340-gtklibs nvidia340-gtklibs-32bit nvidia340-opencl nvidia340-opencl-32bit
sudo xbps-remove -y nvidia390 nvidia390-dkms nvidia390-libs nvidia390-libs-32bit nvidia390-gtklibs nvidia390-gtklibs-32bit nvidia390-opencl nvidia390-opencl-32bit
sudo xbps-remove -y nvidia470 nvidia470-dkms nvidia470-libs nvidia470-libs-32bit nvidia470-gtklibs nvidia470-opencl
sudo xbps-remove -y nvidia nvidia-dkms nvidia-libs nvidia-libs-32bit nvidia-gtklibs nvidia-opencl nvidia-docker nvidia-container-toolkit nvidia-firmware libnvidia-container libnvidia-container-devel nvidia-vaapi-driver
