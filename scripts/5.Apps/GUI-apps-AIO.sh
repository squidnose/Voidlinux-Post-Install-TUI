#/bin/bash

#AV, Files, Office, Wifi
echo "Basic Internet and AV utils: firefox, octoxbps, mpv, vlc, kolourpaint, tuxpaint, shotcut, spectalce, , Parabolic(yt-dlp)"
sudo xbps-install octoxbps firefox gwenview mpv vlc kolourpaint tuxpaint shotcut spectacle
flatpak install flathub org.nickvision.tubeconverter

echo "Remote acces: RustDesk, Remminia"
sudo xbps-install remmina remmina-kwallet
flatpak install flathub com.rustdesk.RustDesk

echo "AV editing: Gimp, Krita, Kdenlive, Audacity, handbrake, easytag, brasero "
flatpak install flathub org.gimp.GIMP org.audacityteam.Audacity
sudo xbps-install krita kdenlive handbrake easytag brasero

echo "KDE apps: Kwalet GUI, Kde connect, Firewall, ark(archive manager), krename (like doubble comander)"
sudo xbps-install kwalletmanager kdeconnect plasma-firewall ufw ark krename

echo "Wifi utils: Linssid, wifi hotspot"
sudo xbps-install linux-wifi-hotspot linssid

echo "Office and Files: Libreoffice, Onlyoffice, Kcalc, korganizer, xournalpp, Flash Cards,"
sudo xbps-install libreoffice kcalc korganizer xournalpp
flatpak install flathub org.onlyoffice.desktopeditors  io.github.david_swift.Flashcards

echo "files: Pika Backup, localsend, transmission(Torrent), Switchero"
sudo xbps-install transmission-qt
flatpak install flathub org.gnome.World.PikaBackup org.localsend.localsend_app io.gitlab.adhami3310.Converter

echo "OBS with virtual camera + Gpu Screen Recorder"
flatpak install flathub com.dec05eba.gpu_screen_recorder com.obsproject.Studio
#virtual camera
sudo xbps-install v4l2loopback





#Emulation, Translation and Gaming
echo "Wine - Windows Aplication Translation Layer + Dosbox + 86BOX:"
sudo xbps-install wine wine-32bit wine-gecko wine-mono winetricks winegui dosbox
flatpak install flathub net._86box._86Box

echo "Games: Mangohud, Minecraft/PrismLaucher, Luanti, steam"
sudo xbps-install PrismLauncher openjdk8-jre openjdk17-jre openjdk21-jre luanti MangoHud MangoHud-32bit steam
#mkdir ~/.config/MangoHud/
#cp MangoHud.conf ~/.config/MangoHud/


echo "Benchmakring: Geekbench, Furmark"
flatpak install flathub com.geekbench.Geekbench6
flatpak install flathub com.geeks3d.furmarkeasytag



#HW/SW tweeking, Programing
echo "System Monitoring and Config Utils: system monitor, grub customizer, system log, MissionCenter, Fan Controll"
sudo xbps-install gnome-system-monitor ksystemlog grub-customizer
flatpak install flathub io.missioncenter.MissionCenter io.github.wiiznokes.fan-control

echo "Disk Utilities: Disks, gparted, filelight and baobab(disk usage), sweeper(file cleanup), gsmartcontroll(disk health)"
sudo xbps-install gnome-disk-utility gparted baobab filelight sweeper gsmartcontrol smartmontools nvme-cli

echo "HW utils: CPU-x, Hardinfo, Corectl + LACT(msi afterburner like), Inspector, GPU viewer"
sudo xbps-install CPU-X hardinfo corectrl LACT
flatpak install flathub io.github.nokse22.inspector io.github.arunsivaramanneo.GPUViewer

echo "Serial Comms: Chirp (Amature radios), Arduino IDE (1.8 and 2.X), Piper (Gaming Mouse Conf)"
sudo xbps-install chirp arduino piper libratbag
flatpak install flathub cc.arduino.IDE2
sudo usermod -aG dialout $USER

echo "Programing: Logisim Evolution, Codeblocks, Visual Studio Code"
sudo xbps-install logisim-evolution codeblocks
flatpak install flathub com.visualstudio.code

echo "Console apps: ifuse, oneko, cmatrix, 7zip+unrar, btop, glxinfo, clamav"
sudo xbps-install ifuse oneko 7zip 7zip-unrar cmatrix btop glxinfo clamav lspci lsusb

echo "Flatpak Apps + appimage Pool"
flatpak install flathub io.github.flattool.Warehouse
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub io.github.prateekmedia.appimagepool

echo "Power Management"
sudo xbps-install tlp cpupower power-profiles-daemon

