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
### Basic Setup
- core-utilities.sh = Installes my favourite terminal Goddies like Fastfetch, Htop and Nano
- dkms.sh = Important to Run if you want to use Nvidia Drivers.
- repos.sh = Important for Steam and Flatpak applications
### GPU drivers
  - amd-ati-RADV.sh = For all AMD and ATI cards. It includes the RADV vulkan driver whitch is partially developed by valve and has often better performance to AMDVLK.
  - amd-AMDVLK.sh = For AMD RDNA gpus and up(RX 5000+).It includes the AMDVLK vulkan driver from AMD. It may work better in certin situations. (Less Reccomended)
  - Switch-to-AmdGPU-GCN1.sh = Enable AMDGPU drivers for GCN1 GPUS. Performs better in GPU intensive situations. Has better support. May be more CPU intensive. Disables VGA output from DVI-I adapters(is being worked on). 
  - intel-gpu-drivers.sh = for all intel GPUS. 
  - nvidia390-Fermi.sh = For nvidia 400 and 500 series. Some Fremi gpus may have 600 or 700 naming(eg. GT 710M). Open CPU-x and consult with techpowerup. You must select linux 6.1 at startup.
  - nvidia470-Kepler.sh = For nvidia 600 and 700 series. Some 600 and 700 series may be have Fermi chip, consult CPU-x and Techpowerup. You must select linux 6.12 at startup.
  - nvidia-New-Stable.sh = New stable nvidia driver. For GTX 900 and 1000 series and newer. Soon will only support only RTX 2000 and GTX 1600 series and newer.
  - nvidia-Nouveau-drivers.sh = FOSS driver for Nvidia. For any nvidia card. Will work better on older GPUS.
  - emulate-vulkan-lavapipe.sh = is for Non vulkan cards like amd Terrascale, Intel HD 3000 and older, Nvidia only when using nouveau. It uses CPU to emulate Vulkan.
### Language Setup 
- TBD
### Audio Video GUI
-  pipewire-alsa.sh = Pipewire is Awesome for Video and Audio streaming on wayland. Do remeber to set pipewire to autorun in your desktop enviroment. 
-  kde-plasma.sh = KDE plasma for a Similar GUI as steamdeck in Destkop mode.
### Apps
- TBD
### Power Managment
- Power-Porfiles-Daemon.sh = Power performance slider backend. May not yield best battery life.
### Void Managment
- Clear-XBPS-cache.sh = Removes Old cached packages. Only run if you have no problems with existing packages and whole system.
- Remove-Old-Kernels.sh = Uses VKpurge to remove unused kernels. Usefull to run for people with nvidia GPUs or other DKMS SW. Run only when you are sure that kernel update did not brake DKMS modules (like nvidia driver). 

### Games
- PrismLauncher.sh = Minecraft Java Launcher
- luanti.sh = Free Minecraft Look alike
- mangohud.sh = in game FPS counter
- steam.sh = Choose between Steam XBPS and Flatpak. XBPS is highly reccomended. 

GLHF
