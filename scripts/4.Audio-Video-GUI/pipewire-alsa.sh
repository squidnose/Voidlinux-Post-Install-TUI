#/bin/bash
echo "Install Pipewire"
echo "YOU WILL HAVE TO CONFIGURE PIPEWIRE TO AUTOSTART IN YOUR DESKTOP ENVIROMENT"
sudo xbps-install alsa-pipewire alsa-ucm-conf pipewire sof-firmware
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -sf /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -sf /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
sudo mkdir -p /etc/alsa/conf.d
sudo ln -sf /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/
sudo ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/
echo "!!!CONFIGURE PIPEWIRE TO AUTOSTART IN YOUR DESKTOP ENVIROMENT!!!"
echo "For Kde Plasma:"
echo "Settings -> Autostart -> Add new -> Aplication -> type in: pipewire"
