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
## What Scripts To run?
- core-utilities.sh installes my favourite terminal Goddies like Fastfetch, Htop and Nano
- dkms.sh Is important to Run if you want to use Nvidia Drivers.
- Repos are important for Steam and Flatpak applications
- GPU drivers are based on the GPU you have.
  - For all amd GPUs newer than GCN id reccomend the GCN drivers. It includes RADV whitch is developed by valve and has often better performance.
  - The RDNA option is for if AMDVLK works better for you than RADV. (Less Reccomended)
  - If you have a Early GCN card, read the text file provided. DONT RUN IT!
  - I have had problems with the nvidia390 not working, make sure to install a older kernel verison, like linux6.1 withlinux6.1-headers before running the script. The same for nvidia470 and nvidia
  - There will be a nvidia580 script once nvidia drops support for Maxwell and Pascall. This will probably require linux6.12 witch is the current defualt on void. 
  -  Pipewire is Awesome for Video and Audio streaming. Do remeber to set pipewire to autorun in your desktop enviroment.
  -  Language setup, Power managemt, Void management are not done yet.

GLHF
