# Voidlinux-Post-Install-Script-TUI
- A whiptale TUI for my voidlinux scripts (Including scripts).
- The Goal is to make configuring and managing Voidlinux easier.
- I you want [Installation Instructions](install.md) open the install.md.

## 1. After installing Void
- After you install voidlinux and reboot, you need to update xbps and your system:
```
sudo xbps-install -Syu
sudo xbps-install -u xbps
sudo xbps-install -Syu
```
- I also recomend to reboot:
```
sudo reboot
```
## 2. Clone the repo
- install needed dependencies:
```
sudo xbps-install -Su git dialog newt
```
- clone the repo into /home/<user>/Voidlinux-Post-Install-TUI
```
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git
cd Voidlinux-Post-Install-TUI
```
## 3.1 Instalation Wizard (1.Post-Install-Setup-Wizzard.sh)
- This setup wizzard is a linear setup helper.
- Not all scripts are included in the Wizard.
- This is meant for users that dont know what to run.
```
chmod +x 1.Post-Install-Setup-Wizzard.sh
./1.Post-Install-Setup-Wizzard.sh
```
## 3.2 VOID-TUI.sh
- This is the main script that uses my [[Linux-Script-Manager]](https://codeberg.org/squidnose-code/Linux-Script-Runner)
- It is a non-linear menu of all the scripts
```
chmod +x VOID-TUI.sh
./VOID-TUI.sh
```
## 4.VOID-TUI.desktop
- If you want a desktop icon, copy this file to your desktop:
```
VOID-TUI.desktop
```
- This .desktop file expects the script to be in /home/<user>/Voidlinux-Post-Install-TUI
- The git versoin runs the VOID-TUI-updater.sh
- The Release version simply runs VOID-TUI.sh

**You may need to add executable permissions in the file properties. or remove the .download suffix(XFCE).**
### (Git version only )VOID-TUI-updater.sh
- download nessesery dependencies (and thus ask for password)
- update the script you have downloaded from git.
- if internet connection is not avaliable it will run without updating.

## 5. Documentation
- All documentaion for VOID-TUI.sh is on my codeberg: [[Linux-Script-Manager]](https://codeberg.org/squidnose-code/Linux-Script-Runner)
- If dont know what scripts to run, you can read any 0.info.md files in the script.
- You can read 0.info.md online: [[What to run? 0.info.md]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/blob/main/scripts/0.info.md)

The wiki is a work in progress: https://github.com/squidnose/Voidlinux-Post-Install-TUI/wiki

## 6. Disclaimer:
```
I did get help from LLMs.
However, this is not a copy and paste slop script. Many hours have gone into making it human readeble. 
if you dont feel comfortable with me getting help from AI, feel free to read the info.md files. 
```
## 7. Liscence
The code is Licensed under the BSD-2-Clause License.
