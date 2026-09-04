#!/bin/bash
#============================ Term Size============================
## Detect terminal size
### incase tput is not found, sets to fixed value
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT * 3 / 4 ))
WIDTH=$(( TERM_WIDTH * 4 / 5 ))
MENU_HEIGHT=$(( HEIGHT - 10 ))

### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu

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

#==================================== Install Main Packages (64 bit) ====================================
TITLE="AMD and ATI cards Terrascale, GCN, RDNA, UDNA. (ATI HD 2000 and up) - Driver Installer"

PACKAGES=(xf86-video-amdgpu xf86-video-ati mesa-dri mesa-opencl ocl-icd mesa-vulkan-radeon vulkan-loader Vulkan-Headers Vulkan-Tools gamemode libspa-vulkan mesa-vaapi libva gstreamer1 radeontop nvtop)
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "xf86-video-amdgpu"         "Xorg AMD Radeon RXXX video driver (amdgpu kernel module)" ON
    "xf86-video-ati"            "Xorg ATI Radeon video driver" ON
    "mesa-dri"                  "Mesa DRI drivers" ON
    "mesa-opencl"               "Mesa implementation of OpenCL (r600+ only)" ON
    "ocl-icd"                   "Generic OpenCL ICD loader/demultiplexer" ON
    "mesa-vulkan-radeon"        "Mesa Radeon Vulkan driver (RADV)" ON
    "vulkan-loader"             "Vulkan Installable Client Driver (ICD) loader" ON
    "Vulkan-Headers"            "Vulkan header files" ON
    "Vulkan-Tools"              "Official Vulkan tools and utilities" ON
    "libspa-vulkan"             "Server and user space API to deal with multimedia pipelines - vulkan plugins" ON
    "gamemode"                  "Optimise Linux system performance on demand" ON
    "mesa-vaapi"                "Mesa VA-API drivers" ON
    "libva"                     "Video Acceleration VA-API" ON
    "gstreamer1"                "Core GStreamer libraries and elements (Multimedia Framework)" ON
    "radeontop"                 "View radeon GPU utilization (Radeon and AMDGPU)" ON
    "nvtop"                     "GPUs process monitoring for AMD, Intel and NVIDIA (AMDGPU Only)" ON

)

RAW=$( whiptail --title "$TITLE" --checklist "Do you wish to install all these driver packages?" \
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
TITLE="32 Bit - AMD and ATI cards Terrascale, GCN, RDNA, UDNA. (ATI HD 2000 and up) - Driver Installer"

PACKAGES=(mesa-dri-32bit mesa-opencl-32bit libgamemode-32bit ocl-icd-32bit mesa-vulkan-radeon-32bit vulkan-loader-32bit libspa-vulkan-32bit mesa-vaapi-32bit libva-32bit gstreamer1-32bit)
## Menu list entries:
### "PACKAGE" "DESCRIPTION" "OFF/ON"
### OFF/ON refers if the menu item will be automaticly selected(ON) or de-selected(OFF)
MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "mesa-dri-32bit"                  "Mesa DRI drivers (32bit)" ON
    "mesa-opencl-32bit"               "Mesa implementation of OpenCL (r600+ only) (32bit)" ON
    "ocl-icd-32bit"                   "Generic OpenCL ICD loader/demultiplexer (32bit)" ON
    "mesa-vulkan-radeon-32bit"        "Mesa Radeon Vulkan driver (RADV)" ON
    "vulkan-loader-32bit"             "Vulkan Installable Client Driver (ICD) loader (32bit)" ON
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

whiptail --title "$TITLE" --msgbox "If you are using a GCN 1 or 2 GPU (HD 7000, RX 200/300 series)\nAnd also using Linux kernel 6.18 and older.\nYou May want to run:\n\namd-Switch-to-AmdGPU-GCN1.sh\nFound in: 2.Drivers => Graphics" $HEIGHT $WIDTH


exit 0
