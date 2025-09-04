#/bin/bash
echo "Installing KDE Plasma, Network manager(Ready for eduroam):"
sudo xbps-install -Syu kde-plasma kde-baseapps xorg wayland plasma-integration sddm dbus NetworkManager python3-dbus plasma-browser-integration

echo "Installing KDE integrations: Google-drive, Browser Inegration, Firewall Information gathering(Local):"
sudo xbps-install -Syu kio-gdrive plasma-browser-integration ufw plasma-firewall clinfo qt6-wayland-tools aha drkonqi

echo "Install kde apps: Notepad, Terminal, Files, Help-Center; Screenshots; Unzip, Unrar; Paint; Bulk Renamer; System Password Manager;Disk space analyzer; App Store for flatpak and Kde addons; GUI package manager for XBPS"
sudo xbps-install -Syu spectacle ark 7zip-unrar kolourpaint krename kwalletmanager filelight discover octoxbps

echo "installing file previews. To configure it, go to Configure Dolphin -> General -> Previews." 
sudo xbps-install -Syu kdegraphics-thumbnailers ffmpegthumbs

echo "installing Themes for: Cursor, Icons" 
sudo xbps-install -Syu breeze-cursors breeze
