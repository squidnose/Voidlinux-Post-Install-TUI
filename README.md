# Voidlinux-Post-Install-Script-TUI-
A ncurses TUI for my voidlinux scripts (Including scripts). 

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
## Script Coletion (Void-post-install-script.sh)
If you want a desktop icon, copy over theese files based on what DE you have:
- Run-New-Void-TUI.desktop (for most desktop enviroments)
- Run-New-Void-TUI-XFCE.sh (For XFCE and is hard-coded to use xfce4-terminal but you can change it based on what terminal you use by editing the file)

**Dont forget to add executable permissions in the file properties.**

## Instructions
- Use arrow keys to move up and down in the menu
![Alt text](https://squidnose.cz/lib/exe/fetch.php?media=0:void-tui.png)
- Press enter to either:
  - Enter a folder
  - Read a file
  - Run a script
- You will be prompted before running a scirpt to make sure you meant to run it.
- You will need to press enter after running a script so that you will read the output incase there is a Error.
- Run-New-Void-TUI-XFCE.sh and Run-New-Void-TUI-KDE.sh are desktop scripts that will donwload the latest version of my TUI and install it into /tmp(Deleted after reboot)
  - You will need to Right click and add executable permissions!!! 
  - If you want a offline version of my TUI, consider this: https://github.com/squidnose/VoidLinux-Script-Manager
 
[[What Scripts To run?]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/blob/main/scripts/0.info.md)
