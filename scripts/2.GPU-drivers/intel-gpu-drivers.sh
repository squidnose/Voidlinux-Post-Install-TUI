#!/bin/bash
echo "For Intel cards Gen 5 and above (Intel HD 2000+)"
echo "May have issues with Intel Gen 1-4 (GMA and similar). Solution is mesa-amber (Archlinux) or Debian Linux."

echo "Installing 2D Xorg accelaration packages"
sudo xbps-install -Sy xf86-video-intel

echo "Installing 3D accelaration packages"
sudo xbps-install -Syu mesa-dri mesa-opencl gamemode mesa-vulkan-intel vulkan-loader Vulkan-Headers Vulkan-Tools ocl-icd
echo "Installing Video accelaration packages"
sudo xbps-install -Syu mesa-vaapi mesa-vdpau intel-video-accel libspa-vulkan libva

echo "Installing 32bit 3D accelaration packages, Will fail on Musl"
sudo xbps-install -Syu mesa-dri-32bit mesa-opencl-32bit mesa-vulkan-intel-32bit vulkan-loader-32bit ocl-icd-32bit
echo "Installing 32bit Video accelaration packages, Will fail on Musl"
sudo xbps-install -Syu mesa-vaapi-32bit mesa-vdpau-32bit libspa-vulkan-32bit libva-32bit
