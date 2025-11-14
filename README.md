# Voidlinux-Post-Install-Script-TUI
A whiptale TUI for my voidlinux scripts (Including scripts).

The Goal is to make configuring and managing Voidlinux easier.

I you want [Installation Instructions](install.md) open the install.md

## Instalation Wizard (1.Post-Install-Setup-Wizzard.sh)
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
chmod +x 1.Post-Install-Setup-Wizzard.sh
./1.Post-Install-Setup-Wizzard.sh
``` 
### VOID-TUI.desktop
If you want a desktop icon, copy this file to your desktop:
```
VOID-TUI.desktop
```
This file will run VOID-TUI-updater.sh

**You may need to add executable permissions in the file properties. or remove the .download suffix(XFCE).**
### VOID-TUI-updater.sh
- download nessesery dependencies (and thus ask for password)
- update the script you have downloaded from git.
- if internet connection is not avaliable it will run without updating.

  
### [[What to run? - Wiki]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/wiki/About)

Disclaimers:
```
This is a work in progress and has the opportunity to break your system.
I use it on all my void machines, but i suggest to first use it in a VM. 
```
```
I did get help from chatgpt. 
if you dont feel comfortable with me getting help from AI, feel free to read the info.md files. 
```
