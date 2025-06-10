#/bin/bash
echo "installing 64 bit wine"
sudo xbps-install -y wine wine-gecko wine-mono winetricks winegui
echo "Installing wine-32bit"
sudo xbps-install -y wine-32bit
echo "This will fail on MUSL"
