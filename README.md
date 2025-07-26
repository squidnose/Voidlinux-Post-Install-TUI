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
- core-utilities.sh = installes my favourite terminal Goddies like Fastfetch, Htop and Nano
- dkms.sh = Is important to Run if you want to use Nvidia Drivers.
- repos.sh = are important for Steam and Flatpak applications
- GPU drivers:
  - amd-GCN-gpu-drivers.sh = RADV vulkan driver. For all amd GPUs newer than GCN. It includes RADV whitch is partially developed by valve and has often better performance.
  - amd-RDNA-gpu-drivers.sh = AMDVLK vulkan driver. Vulkan drivers from AMD it may work better in certin situations. (Less Reccomended)
  - emulate-vulkan-lavapipe.sh = is for Non vulkan cards like amd Terrascale, Intel HD 3000 and older, Nvidia only when using nouveau. It uses CPU to emulate Vulkan. 
  - intel-gpu-drivers.sh = for all intel GPUS. 
  - nvidia-fermi-gpu-drivers.sh = Nvidia390 driver. For nvidia 400 and 500 series. Some Fremi gpus may have 600 or 700 nameing. Open CPU-x and consult with techpowerup. You must select linux 6.1 at startup.
  - nvidia-kepler-gpu-drivers.sh = Nvidia470 driver. For nvidia 600 and 700 series. Some 600 and 700 series may be have Fermi chip, consult CPU-x and Techpowerup. You must select linux 6.1 at startup.
  - nvidia-gpu-drivers.sh = New stable nvidia driver. For 900 and 1000 and newer. Soon will only support only RTX 2000 and gtx 1600 and newer.
  - nvidia-Nouveau-drivers.sh = FOSS driver for Nvidia. For any nvidia card. Will work better on older GPUS.  
-  pipewire-alsa.sh = Pipewire is Awesome for Video and Audio streaming on wayland. Do remeber to set pipewire to autorun in your desktop enviroment. 
-  kde-plasma.sh = KDE plasma for a Similar GUI as steamdeck in Destkop mode. 
-  Language setup, Power managemt, Void management are not done yet.

GLHF
