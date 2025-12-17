#!/bin/bash
echo "Install and Configure Virtualbox"
read -p "Press Enter to install, CTRL+c to cancel"
echo "Installing VirtualBox"
sudo xbps-install -y virtualbox-ose virtualbox-ose-guest virtualbox-ose-dkms
sudo ln -s /etc/sv/virtvboxd/ /var/service/
sudo usermod -aG vboxusers $USER
echo "Enabling Kernel modules"
sudo modprobe vboxdrv
echo "vboxdrv" | sudo tee /etc/modules-load.d/virtualbox.conf > /dev/null
echo "vboxnetflt" | sudo tee -a /etc/modules-load.d/virtualbox.conf > /dev/null
echo "vboxnetadp" | sudo tee -a /etc/modules-load.d/virtualbox.conf > /dev/null

