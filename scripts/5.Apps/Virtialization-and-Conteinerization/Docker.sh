#/bin/bash
echo "Docker + Distrobox"
sudo xbps-install docker
sudo ln -s /etc/sv/docker /var/service/
sudo sv start docker
sudo sv status docker
sudo groupadd docker
sudo usermod -aG docker $USER


