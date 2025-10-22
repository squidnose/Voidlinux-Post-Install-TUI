# My prefered Method to install Voidlinux
## 1. Choose a .ISO
### By platforms:
- x86_64 - For most PCs and Laptops
- i686   - Older PCs and Laptops, v Pentium 4 and higher
- arm    - ARM single board computers like the raspberry PI, or any ARM powerd device. 
- containers - For containers on servers(Not relevent for this tutorial)
### By compiler

- Glibc - The most compatible, needed for Nvidia a Broadcom and 32 bit support.
- Musl  - Lower memory usage, Much less compatible. Do research before you use. 
### By contents:
- XFCE live image - Live grafical XFCE enviroment, includes void-installer script.
- Base live image - Live terminal enviroment(No GUI), includes void-installer script.
- rootfs tarball  - Contents of the Root Filesystem. Use if you know what you are doing. 
### What to choose:
- If i want anything other that XFCE i use the base install ISO from the downloads page: https://voidlinux.org/download/
- For most people id reccomed Glibc version.
## 2. Disk Prep (Optional)
### Install media
- Id reccomend using ventoy for the install. 
- I also reccomed adding Refind ISO to the Ventoy disk!
  - Some Machines dont recognize the Voidlinux UEFI on first boot. 
  - Grab the CR-R image file: https://www.rodsbooks.com/refind/getting.html
### Pre-Partiotion Disks 
- You can partition your disk in void-installer. 
- You dont have to do it this way
- But i like to do it graphically in Gnome Disks Utility
  - Its a nice GUI for disk managment.
- If you are using the XFCE variant, do this:
```
sudo xbps-install -Syu xbps
sudo xbps-install -Sy gnome-disk-utility 
```
- Then look for the app Disks
- In Gnome Disks set theese partitions:
  - 1-2 GB partition for Boot partiotion
  - 2xRAM - For swap. (Optional)
  - 40-120 GB / for system root partition (Alias C drive)
  - 30 GB or more for /home for user data partition (Alias D drive with moved C:\Users\Username to D)

## 3. Void-installer
The official Installer from the Voidlinux team. 
```
sudo void-installer
```
password is voidlinux
- Theese are important Steps i use in Void-installer:
  - Keyboard: US
  - Network I try not to setup using WiFi, because in the non XFCE version it uses WPA supplicant which i dont like to use. SO either use XFCE or just a Ethernet cable.
  - Set source as Local ISO(For modern UEFI systems)
  - Hostname: VoidlingX (Whatever you want:))
  - Locale: en_US.UTF-8 UTF-8
  - Timezone: Europe/Prague
  - Root Password same as for User
  - Username has 2 setting, Displayed name and username. I set to the same, with all lowercase.
  - Bootloader set to disk you want to install to Not to Ventoy...
  - Partitions I like Gnome Disks but the Terminal based options are not bad.
  - In filesystem use the partitions set from earlier:
    - /boot/efi 1-2 GB
    - 2xRAM - For swap. (Optional)
    - / 40-120 GB
    - /home 30+ GB
  - Install usually doesnt take long. But generating InitramFS can take longer, based on what HW you have
  - You will be presented with services to enable or disable. 
    - Up and Down arrow keys to select a service. 
    - Use spacebar to Enable or Disable.
    - The * shows its enabled.
  - Enable:
    - Network manager (For simpler networking)
    - Alsa (For audio)
  - Disable: 
    - WPA supplicant(Textfile based config for WiFi)
- The installer will either ask to reboot or you can:
```
sudo reboot
```
## 4. Update
- After a sucsesfull reboot, it is important that you update
```
sudo xbps-install -Syu xbps
sudo xbps-install -Syu
```
### No network connection?
- To find out if your PC has connection:
```
ping google.com
```
CTRL+C To stop the ping

- to connect wifi use nmcli:
```
nmcli device wifi connect "Your-SSID" --ask
```


## 5. Install my Voidlinux-Post-Install-Script-TUI
- A.install dependencies
```
sudo xbps-install -Syu git dialog newt
```
- B. Clone Repository
```
git clone https://github.com/squidnose/Voidlinux-Post-Install-TUI.git
```
- C. Open the cloned repository
```
cd Voidlinux-Post-Install-TUI
```
- D. Run the One time Wizard 
```
chmod +x 1.Post-Install-Setup-Wizzard.sh
./1.Post-Install-Setup-Wizzard.sh
```
- E. You can also just run the Void-TUI
```
chmod +x VOID-TUI.sh
./VOID-TUI.sh
```
## [[What Scripts To run?]](https://github.com/squidnose/Voidlinux-Post-Install-TUI/blob/main/scripts/0.info.md)
