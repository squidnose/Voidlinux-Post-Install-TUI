#/bin/bash
if whiptail --title "WARNING!!!" --yesno "This may break Networking for Qemu/KVM virtual Machines and other\nI do not know yet how to fix this\nRun at your own risk!!!" 10 60; then

echo "To install Distrobox you need Docker, do you wish to install and configure Docker?"
echo "Carefull, my method of installing docker isnt very safe, consider using LXC+VirtManager"
read -rp "Install Docker? (y/N): " install_docker

install_docker=${install_docker,,} # Convert to lowercase just in case:)

if [[ "$install_docker" == "y" || "$install_docker" == "yes" ]]; then
sudo xbps-install docker
sudo ln -s /etc/sv/docker /var/service/
sudo sv start docker
sudo sv status docker
sudo groupadd docker
sudo usermod -aG docker $USER

fi

curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
flatpak install flathub io.github.dvlv.boxbuddyrs
clear
echo "If you have Nvidia, install nvidia-docker package"
echo "You now need to edit your fstab file"
echo "when you see this:"
echo "UUID=xxxxx-xxx-xxx-xxx-xxxxxxxx / ext4 defaults 0 1"
echo "you add this to it"
echo "UUID=xxxxx-xxx-xxx-xxx-xxxxxxxx / ext4 defaults,shared 0 1"
echo "xxxxx-xxx-xxx-xxx-xxxxxxxx is the UUID number of you drive"

fi
exit 0
