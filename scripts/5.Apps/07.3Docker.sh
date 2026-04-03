#!bin/bash
if whiptail --title "Docker" --yesno "Install Docker and setup?" 15 60; then

read -rp " (y/N):"
sudo xbps-install docker
sudo ln -s /etc/sv/docker /var/service/
sudo sv start docker
sudo sv status docker
sudo groupadd docker
sudo usermod -aG docker $USER
fi
exit 0
