#/bin/bash
echo "For AMD/ATI Terrascale 1,2 and 3 cards (Radeon HD 2000 - 6000)"
#read -p "Press Enter to install, CTRL+c to cancel"
sudo xbps-install mesa-dri mesa-dri-32bit mesa-vaapi mesa-vaapi-32bit mesa-vdpau mesa-vdpau-32bit mesa-opencl mesa-opencl-32bit gamemode xf86-video-ati ocl-icd ocl-icd-32bit
