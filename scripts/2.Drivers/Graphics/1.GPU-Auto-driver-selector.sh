#!/bin/bash
#================ 1. Parameters and Config ================
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
TITLE="GPU auto Installer VoidTUI"
#Colorisation
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m'

#find dir to run scripts
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

#info about gpu model
gpu_info=$(lspci -nn | grep -Ei "vga|3d")
echo "Detected GPU: $gpu_info"
NVIDIA_FIX_DIR="$SCRIPT_DIR/Nvidia-FIX"

#================ 2. Driver Install Functions ================
# Offeres to run an array of diferent fixes for nvidia GPUs
nvidia_fix() {

if whiptail --title "$TITLE" --yesno "Set DRM modeset for Better Wayland support?" $HEIGHT $WIDTH; then
    bash "$NVIDIA_FIX_DIR/Nvidia-FIX-DRM-modeset.sh"
    echo "Ran Nvidia-FIX-DRM-modeset.sh"
fi

if whiptail --title "$TITLE" --yesno "Set Nvidia GPU for primary display?(Reccomended for hybrid laptop graphics)" $HEIGHT $WIDTH; then
    bash "$NVIDIA_FIX_DIR/Nvidia-FIX-Only-Hybrid-Setup.sh"
    echo "Ran Nvidia-FIX-Only-Hybrid-Setup.sh"
fi

if whiptail --title "$TITLE" --yesno "Fix Sleep mode with Nvidia (May reboot system)" $HEIGHT $WIDTH; then
    bash "$NVIDIA_FIX_DIR/Nvidia-FIX-Suspend.sh"
    echo "Ran Nvidia-FIX-Suspend.sh"
fi

if whiptail --title "$TITLE" --yesno "Fix Brighness Controll on Some laptops with Nvidia Only GPUS?" $HEIGHT $WIDTH; then
    bash "$NVIDIA_FIX_DIR/Nvidia-FIX-Brightness-Controll.sh"
    echo "Ran Nvidia-FIX-Brightness-Controll-Nvidia.sh"
fi

# Install Nvidia drivers and select corect driver version based on GPU code name
}
install_nvidia() {
# Detect Nvidia Generation
    if echo "$gpu_info" | grep -q " GF1\| GF2"; then
        echo "Detected Generation: Fermi"
        "$SCRIPT_DIR/nvidia390-Fermi.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " GK1\| GK2"; then
        echo "Detected Generation: Kepler"
        "$SCRIPT_DIR/nvidia470-Kepler.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " GM1\| GM2\| GP1\| GP2\| GV1"; then
        echo "Detected Generation: Maxwell Or Pascal"
        "$SCRIPT_DIR/nvidia580-Maxwell-Pascal-Volta.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " TU1\| TU2"; then
        echo "Detected Generation: Turing"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " GA1\| GA2"; then
        echo "Detected Generation: Ampere"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " AD1\| AD2"; then
        echo "Detected Generation: Ada Lovelace"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
        nvidia_fix
    elif echo "$gpu_info" | grep -q " GB1\| GB2"; then
        echo "Detected Generation: Blackwell"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
        nvidia_fix
    else
        echo "You are either using a older card, or the script failed to recognize your gpu"
        read -p "Install FOSS Nouveau drivers? Enter to install, CTRL+c to cancel"
        "$SCRIPT_DIR/nvidia-Nouveau-drivers.sh"
    fi

}

install_amd() {
    echo "Detected AMD GPU, installing for Terrascale, GCN, RDNA and UDNA."
    "$SCRIPT_DIR/amd-ati-RADV.sh"

}

install_intel() {
    echo "Detected: Intel GPU Gen 5 and Newer"
    "$SCRIPT_DIR/intel-gpu-drivers.sh"
}

install_mesa_glhf() {
#Install mesa GLHF
    sudo xbps-install -Syu mesa
    sudo xbps-install -Syu mesa-32bit #will fail on musl
    echo "32-bit packages will fail on Musl"
}


#================ 3. Manual Menu ================
# Manually select driver packages
manual_drivers()
{
    MANUAL_OPTIONS=(
    #"PACKAGE"      "DESCRIPTION"            "OFF/ON"
    "amd-mesa"          "For AMD/ATI GPUs from HD2400+ (Terrascale+)" OFF
    "intel-mesa"        "For Intel GPUs from Intel HD+ (1.gen Core series+)" OFF
    "nvidia-autodetect" "Automatically detect apropriate driver version" OFF
    "nvidia"            "For Nvidia 16XX+ series (Turing)" OFF
    "nvidia-580"        "For Nvidia 800/900/1000 series (Maxwell, Pascal and Volta)" OFF
    "nvidia-470"        "For Nvidia 600/700 series (Kepler)" OFF
    "nvidia-390"        "For Nvidia 400/500 series (Fermi)" OFF
    "nvidia-mesa"       "Open Source Nvidia drivers (Slower, but works on MUSL)" OFF
    "mesa-generic"      "Simply installs the Mesa driver package" OFF
    )
    CHOICE_GPU=$(whiptail --title "$TITLE" --checklist "You have multiple GPUS\n Manually select what drivers to install:"\
    "$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
    "${MANUAL_OPTIONS[@]}" \
    3>&1 1>&2 2>&3)
    ## The CHOICE_GPU output has " that package managers dont like
    ## The following commands remove quotes and convert into clean array
    CHOICE_GPU=${CHOICE_GPU//\"/}
    ## for reference: ${CHOICE_GPU//pattern/replacement}
    ## explanation:
        ### // replace for all occurrences
        ### \" the patern. The backslash is used inside quotes to prevent confusion in the script. Effectively this pattern is "
    read -r -a SELECTED_DRIVERS <<< "$CHOICE_GPU"
    ## Install Packages
    echo "${SELECTED_DRIVERS[*]}"

    # Run corect driver
    for driver in "${SELECTED_DRIVERS[@]}"; do
        case "$driver" in
            "amd-mesa")
                install_amd
                ;;
            "intel-mesa")
                install_intel
                ;;
            "nvidia-autodetect")
                install_nvidia
                ;;
            "nvidia")
                "$SCRIPT_DIR/nvidia-New-Stable.sh"
                nvidia_fix
                ;;
            "nvidia-580")
                "$SCRIPT_DIR/nvidia580-Maxwell-Pascal-Volta.sh"
                nvidia_fix
                ;;
            "nvidia-470")
                "$SCRIPT_DIR/nvidia470-Kepler.sh"
                nvidia_fix
                ;;
            "nvidia-390")
                "$SCRIPT_DIR/nvidia390-Fermi.sh"
                nvidia_fix
                ;;
            "nvidia-mesa")
                "$SCRIPT_DIR/nvidia-Nouveau-drivers.sh"
                ;;
            "mesa-generic")
                install_mesa_glhf
                ;;
        esac
    done
}

automatic_drivers()
{
#================ 4. Automatic Menu ================
# Automatically detect gpu and run apropriate driver installer
# Detect Vendor
if echo "$gpu_info" | grep -qi "nvidia"; then
    VENDOR="NVIDIA"
    echo -e "${GREEN}Vendor: $VENDOR${NC}"
    install_nvidia
elif echo "$gpu_info" | grep -qi " amd \| ati "; then
    VENDOR="AMD"
    echo -e "${RED}Vendor: $VENDOR${NC}"
    install_amd
elif echo "$gpu_info" | grep -qi "advanced micro devices"; then
    VENDOR="AMD"
    echo -e "${RED}Vendor: $VENDOR${NC}"
    install_amd
elif echo "$gpu_info" | grep -qi " intel "; then
    VENDOR="Intel"
    echo -e "${BLUE}Vendor: $VENDOR${NC}"
    install_intel
else
    if whiptail --title "$TITLE - ! Unknow GPU !" --yesno "Do you wish to manually select drivers?" $HEIGHT $WIDTH; then
        manual_drivers
    else
        whiptail --title "$TITLE" --msgbox "No GPU drivers installed" $HEIGHT $WIDTH
    fi
fi
}

#================ 5 - Main Menu ================
# Automatically run manual gpu driver selector when more than 1 gpu is detected
#check if you have dual gpus
gpu_count=$(lspci -nn | grep -Ei "vga|3d" | wc -l)
if [ "$gpu_count" -gt 1 ]; then
    manual_drivers
else
    AUTO_MANUAL=$(whiptail --title "$TITLE" --menu "Welcome! \nWhat mode do you wish to run?" $HEIGHT $WIDTH $MENU_HEIGHT\
    "automatic" "Automatically detect gpu and run apropriate driver installer"\
    "manual"    "Manually select driver or set of drivers to install"\
    "exit"      "Make no changes to system Graphics drivers" \
    3>&1 1>&2 2>&3) || exit 0
    case "$AUTO_MANUAL" in
        "automatic") automatic_drivers ;;
        "manual") manual_drivers ;;
        *) exit 0 ;;
    esac
fi
exit 0
