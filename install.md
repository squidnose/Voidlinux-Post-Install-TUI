# My prefered Method to install Voidlinux
## Disk Prep
- If i want anything other that XFCE i use the base install ISO from the downloads page: https://voidlinux.org/download/
- For most people id reccomed Glibc version.
- Id reccomend using ventoy for the install. But also add Refind ISO to the Ventoy disk! Some MB dont recognize the Voidlinux UEFI on first boot. Grab the CR-R image file: https://www.rodsbooks.com/refind/getting.html
- If you are using the XFCE variant, id highly suggest to partiton your disks in Gnome Disks. A nice GUI for disk managment:
```
sudo xbps-install -Syu xbps
sudo xbps-install -Sy gnome-disk-utility 
```
You can also boot into a live version of Linux mint and to the partitioning there
- In Gnome Disks set theese partitions:
1-2 GB partition for Boot partiotion
40-120 GB / for system root partition (Alias C drive)
30 or more for /home for user data partition (Alias D drive with moved C:\Users\Username to D)

## Void-installer
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
    - / 40-120 GB
    - /home 30+ GB
  - Install usually doesnt take long. But generating InitramFS can take longer, based on what HW you have
  - When prezented with what service to run, id select with the spacebar: Network manager and Alsa. Make sure WPA supplicant if off.  
