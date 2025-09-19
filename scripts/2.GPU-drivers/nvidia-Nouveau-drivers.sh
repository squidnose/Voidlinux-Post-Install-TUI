#/bin/bash
echo "For NVIDIA cards (Any)"
echo "These are FOSS alternatives to NVIDIA drivers."
echo "Ever since mesa 25.1.6 NVK vulkan driver has been enabled For Maxwell(GTX 900+) and Higher"
echo "Mesa 25.2 will enable NVK on Kepler(GTX 600/700)"
echo "These drivers don't provide the best gaming performance but offer good support for cards no longer supported by NVIDIA."
echo "Recommended for NVIDIA Curie and Tesla (Geforce 6000, 7000 | Geforce 8000, 9000)"
#read -p "Press Enter to install, CTRL+c to cancel"

echo "Installing 2D Xorg accelaration packages"
sudo xbps-install -Sy xf86-video-nouveau
echo "Installing 3D accelaration packages"
sudo xbps-install -Sy mesa-dri mesa-opencl gamemode ocl-icd mesa-vulkan-nouveau vulkan-loader Vulkan-Headers Vulkan-Tools
echo "Installing Video accelaration packages"
sudo xbps-install -Sy mesa-vaapi mesa-vdpau libspa-vulkan libva

echo "Installing 32bit 3D accelaration packages, Will fail on Musl"
sudo xbps-install -Sy mesa-dri-32bit mesa-opencl-32bit libgamemode-32bit ocl-icd-32bit mesa-vulkan-nouveau-32bit vulkan-loader-32bit
echo "Installing 32bit Video accelaration packages, Will fail on Musl"
sudo xbps-install -Sy mesa-vaapi-32bit mesa-vdpau-32bit libspa-vulkan-32bit libva-32bit
