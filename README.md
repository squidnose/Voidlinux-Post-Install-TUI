# Voidlinux-Post-Install-Script-TUI-
A whiptale TUI for my voidlinux scripts (Including scripts). 

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
## Easy Acces 
### VOID-TUI.sh
If you want a desktop icon, copy this file to your desktop:
```
VOID-TUI.desktop
```
This file will run VOID-TUI-updater.sh

**You may need to add executable permissions in the file properties. or remove the .download suffix(XFCE).**
### VOID-TUI-updater.sh
- download nessesery dependencies (and thus ask for password)
- update the script you have downloaded from git.
- if internet connection is not avaliable it will without updateing.

  
## [[What Scripts To run?]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/blob/main/scripts/0.info.md)

## Instructions (In case you dont know how to use a TUI)
- Use arrow keys to move up and down in the menu
![Alt text](https://squidnose.cz/lib/exe/fetch.php?media=0:void-tui.png)
- Press enter to either:
  - Enter a folder
  - Read a file
  - Run a script
- You will be prompted before running a scirpt to make sure you meant to run it.
- You will need to press enter after running a script so that you will read the output incase there is a Error.
 

