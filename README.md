# Voidlinux-Post-Install-Script-TUI-
A ncurses TUI for my voidlinux scripts (Including scripts). 

I you want [Installation Instructions](install.md) open the install.md

## What to do after install
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
  - If you want a offline version of my TUI, consider this: https://github.com/squidnose/VoidLinux-Script-Manager
 
[[What Scripts To run?]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/blob/main/scripts/0.info.md)
