#!/bin/bash
#============================ Term Size============================
# TUI size - with a Border
## Detect terminal size
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))
## Example implementations
### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno --infobox --passwordbox
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu --checklist --radiolist --gauge

# Echlog
LOGFILE="$HOME/.local/state/VOID-TUI/VOID-TUI.log"
echlog()
{
    local msg="$*"
    echo "$msg"
    if [ "$loggs" == "true" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" >> "$LOGFILE"
    fi
}

#==================================== Warning and sugestions ====================================
whiptail --title "$TITLE" --msgbox "Nvidia Mesa - These drivers don't provide the best gaming performance but offer good support for cards no longer supported by NVIDIA." $HEIGHT $WIDTH

if whiptail --title "$TITLE - Remove Nvidia?" --yesno --defaultno "Do you want to remove ALL nvidia propriatary drivers?" $HEIGHT $WIDTH; then
    echo "Remove the nvidia Propriatery drivers from your system?"
    read -p "Press Enter to install, CTRL+c to cancel"
    sudo xbps-remove -y nvidia340 nvidia340-dkms nvidia340-libs nvidia340-libs-32bit nvidia340-gtklibs nvidia340-gtklibs-32bit nvidia340-opencl nvidia340-opencl-32bit
    sudo xbps-remove -y nvidia390 nvidia390-dkms nvidia390-libs nvidia390-libs-32bit nvidia390-gtklibs nvidia390-gtklibs-32bit nvidia390-opencl nvidia390-opencl-32bit
    sudo xbps-remove -y nvidia470 nvidia470-dkms nvidia470-libs nvidia470-libs-32bit nvidia470-gtklibs nvidia470-opencl
    sudo xbps-remove -y nvidia580 nvidia580-dkms nvidia580-libs nvidia580-libs-32bit nvidia580-gtklibs nvidia580-opencl nvidia580-firmware
    sudo xbps-remove -y nvidia nvidia-dkms nvidia-libs nvidia-libs-32bit nvidia-gtklibs nvidia-opencl nvidia-docker nvidia-container-toolkit nvidia-firmware libnvidia-container libnvidia-container-devel nvidia-vaapi-driver

fi
#==================================== Install Main Packages (64 bit) ====================================
TITLE="For any NVIDIA GPU - Driver Installer"

PACKAGES=(xf86-video-nouveau mesa-dri mesa-opencl ocl-icd mesa-vulkan-nouveau vulkan-loader Vulkan-Headers Vulkan-Tools libspa-vulkan gamemode mesa-vaapi libva gstreamer1 nvtop)
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "xf86-video-nouveau"          "Xorg DDX Intel video driver" ON
    "mesa-dri"                  "Mesa DRI drivers" ON
    "mesa-opencl"               "Mesa implementation of OpenCL" ON
    "ocl-icd"                   "Generic OpenCL ICD loader/demultiplexer" ON
    "mesa-vulkan-nouveau"         "Mesa Intel Vulkan driver" ON
    "vulkan-loader"             "Vulkan Installable Client Driver (ICD) loader" ON
    "Vulkan-Headers"            "Vulkan header files" ON
    "Vulkan-Tools"              "Official Vulkan tools and utilities" ON
    "libspa-vulkan"             "Server and user space API to deal with multimedia pipelines - vulkan plugins" ON
    "gamemode"                  "Optimise Linux system performance on demand" ON
    "mesa-vaapi"                "Mesa VA-API drivers" ON
    "libva"                     "Video Acceleration VA-API" ON
    "gstreamer1"                "Core GStreamer libraries and elements (Multimedia Framework)" ON
    "nvtop"                     "GPUs process monitoring for AMD, Intel and NVIDIA " ON

)

RAW=$(whiptail --title "$TITLE" --checklist "Do you wish to install all these driver packages?" \
    $HEIGHT $WIDTH $MENU_HEIGHT "${MANUAL_OPTIONS[@]}" \
    3>&1 1>&2 2>&3) || exit 0
## The RAW output has " that package managers dont like
## The following commands remove quotes and convert into clean array
RAW=${RAW//\"/}
## for reference: ${RAW//pattern/replacement}
## explanation:
    ### // replace for all occurrences
    ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "

read -r -a SELECTED_PACKAGES <<< "$RAW"
## Install Packages
echlog "Installing Selected Packages: ${SELECTED_PACKAGES[*]}"
sudo xbps-install -Syu "${SELECTED_PACKAGES[@]}"

#==================================== Install Main Packages (64 bit) ====================================
TITLE="32 Bit - For Intel cards Gen 5 and above (Intel HD 2000+) - Driver Installer"

PACKAGES=(mesa-dri-32bit mesa-opencl-32bit ocl-icd-32bit mesa-vulkan-intel-32bit vulkan-loader-32bit libgamemode-32bit libspa-vulkan-32bit mesa-vaapi-32bit libva-32bit gstreamer1-32bit)
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "mesa-dri-32bit"                  "Mesa DRI drivers (32bit)" ON
    "mesa-opencl-32bit"               "Mesa implementation of OpenCL (r600+ only) (32bit)" ON
    "ocl-icd-32bit"                   "Generic OpenCL ICD loader/demultiplexer (32bit)" ON
    "mesa-vulkan-intel-32bit"         "Mesa Intel Vulkan driver" ON
    "vulkan-loader-32bit"             "Vulkan Installable Client Driver (ICD) loader (32bit)" ON
    "libgamemode-32bit"               "Optimise Linux system performance on demand - shared libraries (32bit)" ON
    "libspa-vulkan-32bit"             "Server and user space API to deal with multimedia pipelines - vulkan plugins (32bit)" ON
    "mesa-vaapi-32bit"                "Mesa VA-API drivers (32bit)" ON
    "libva-32bit"                     "Video Acceleration VA-API (32bit)" ON
    "gstreamer1-32bit"                "Core GStreamer libraries and elements (Multimedia Framework) (32bit)" ON
)

RAW=$( whiptail --title "$TITLE" --checklist "Do you wish to install all these driver packages?\n\n!THIS WILL NOT WORK ON MUSL AND i686 ARCHITECTURES!" \
    $HEIGHT $WIDTH $MENU_HEIGHT "${MANUAL_OPTIONS[@]}" \
    3>&1 1>&2 2>&3) || exit 0
## The RAW output has " that package managers dont like
## The following commands remove quotes and convert into clean array
RAW=${RAW//\"/}
## for reference: ${RAW//pattern/replacement}
## explanation:
    ### // replace for all occurrences
    ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "

read -r -a SELECTED_PACKAGES <<< "$RAW"
## Install Packages
echlog "Installing Selected Packages: ${SELECTED_PACKAGES[*]}"
sudo xbps-install -Syu "${SELECTED_PACKAGES[@]}"

exit 0
