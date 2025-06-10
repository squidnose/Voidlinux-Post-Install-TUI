#/bin/bash
echo "Install KDE plasma and KDE apps?"
#read -p "Press Enter to install, CTRL+c to cancel"
echo "Installing KDE Plasma, Network manager(Ready for eduroam):"
sudo xbps-install kde-plasma kde-baseapps xorg wayland plasma-integration sddm dbus NetworkManager python3-dbus

echo "Installing KDE integrations: Google-drive, Browser Inegration, Firewall Information gathering(Local):"
sudo xbps-install kio-gdrive plasma-integration ufw plasma-firewall clinfo qt6-wayland-tools aha

echo "Install kde apps: Notepad, Terminal, Files, Help-Center; Screenshots; Unzip, Unrar; Paint; Bulk Renamer; System Password Manager;Disk space analyzer; App Store for flatpak and Kde addons; GUI package manager for XBPS"
sudo xbps-install kde-baseapps spectacle ark 7zip-unrar kolourpaint krename kwalletmanager filelight discover octoxbps

echo "Enabling services:"
sudo ln -s /etc/sv/dbus/ /var/service
sudo ln -s /etc/sv/sddm/ /var/service
sudo ln -s /etc/sv/NetworkManager/ /var/service

echo "Chek if services dbus, sddm and Network Manager are enabled:"
ls -1 /var/service
echo "You may need to restart"

