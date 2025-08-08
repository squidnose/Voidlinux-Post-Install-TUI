#/bin/bash
echo "Install KDE plasma and KDE apps?"
echo "!!!THIS WILL REBOOT YOUR COMPUTER!!!"
read -p "Press Enter to continue, CTRL+c to cancel"
echo "Installing KDE Plasma, Network manager(Ready for eduroam):"
sudo xbps-install -Syu kde-plasma kde-baseapps xorg wayland plasma-integration sddm dbus NetworkManager python3-dbus plasma-browser-integration

echo "Installing KDE integrations: Google-drive, Browser Inegration, Firewall Information gathering(Local):"
sudo xbps-install -Syu kio-gdrive plasma-integration ufw plasma-firewall clinfo qt6-wayland-tools aha

echo "Install kde apps: Notepad, Terminal, Files, Help-Center; Screenshots; Unzip, Unrar; Paint; Bulk Renamer; System Password Manager;Disk space analyzer; App Store for flatpak and Kde addons; GUI package manager for XBPS"
sudo xbps-install -Syu kde-baseapps spectacle ark 7zip-unrar kolourpaint krename kwalletmanager filelight discover octoxbps

echo "installing file previews. To configure it, go to Configure Dolphin -> General -> Previews." 
sudo xbps-install -Syu kdegraphics-thumbnailers ffmpegthumbs

echo "Enabling services:"
sudo ln -s /etc/sv/dbus/ /var/service
sudo ln -s /etc/sv/NetworkManager/ /var/service

dms=("lightdm" "gdm" "lxdm" "slim" "xdm" "ly")

for dm in "${dms[@]}"; do
    if [ -L "/var/service/$dm" ]; then
        echo "Disabling $dm..."
        sudo rm "/var/service/$dm"
    fi
done

# Enable and start SDDM
if [ ! -L /var/service/sddm ]; then
    echo "Enabling SDDM..."
    sudo ln -s /etc/sv/sddm /var/service/
fi
sudo reboot

