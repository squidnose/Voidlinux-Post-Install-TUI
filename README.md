# Voidlinux-Post-Install-Script-TUI-
A ncurses TUI for my voidlinux scripts (Including scripts). 

# What to do after install
After a install of voidlinux using voidlinux-installer do this:
```
sudo xbps-install -Syu
sudo xbps-install -u xbps
sudo xbps-install -Syu
sudo reboot
```
```
sudo xbps-install -S git dialog newt
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git
cd Voidlinux-Post-Install-TUI
chmod +x Void-post-install-script.sh
./Void-post-install-script.sh
```
