#/bin/bash
echo "Installing KDE Plasma, Network manager(Ready for eduroam):"
sudo xbps-install -Sy kde-plasma kde-baseapps xorg wayland plasma-integration sddm dbus NetworkManager python3-dbus plasma-browser-integration

echo "Installing KDE integrations: Google-drive, Browser Inegration, Firewall Information gathering(Local):"
sudo xbps-install -Sy kio-gdrive plasma-browser-integration ufw plasma-firewall clinfo qt6-wayland-tools aha drkonqi

echo "Install kde apps: Notepad, Terminal, Files, Help-Center; Screenshots; Unzip, Unrar; Paint; Bulk Renamer; System Password Manager;Disk space analyzer; App Store for flatpak and Kde addons; GUI package manager for XBPS"
sudo xbps-install -Sy spectacle ark 7zip-unrar kolourpaint krename kwalletmanager filelight discover octoxbps flatpak-kcm

echo "Installing calendar Integrations and kdeconnect kdepim"
sudo xbps-install -Sy kio-gdrive kontact calendarsupport akonadi-calendar kdepim-addons kdepim-runtime akonadi-contacts akonadi-import-wizard kdeconnect

echo "installing file previews. To configure it, go to Configure Dolphin -> General -> Previews." 
sudo xbps-install -Sy kdegraphics-thumbnailers ffmpegthumbs

echo "installing Themes for: Cursor, Icons" 
sudo xbps-install -Sy breeze-cursors breeze
