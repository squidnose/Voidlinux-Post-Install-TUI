#!/bin/bash
echo "This script will remove the nvidia Propriatery driver from your system"
read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-remove -y nvidia340 nvidia340-libs-32bit nvidia340-opencl
sudo xbps-remove -y nvidia390 nvidia390-libs-32bit nvidia390-opencl
sudo xbps-remove -y nvidia470 nvidia470-libs-32bit nvidia470-opencl
sudo xbps-remove -y nvidia nvidia-libs-32bit nvidia-opencl nvidia-docker
