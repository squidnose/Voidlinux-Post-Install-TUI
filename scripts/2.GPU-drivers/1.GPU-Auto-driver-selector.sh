#!/bin/bash
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
nvidia_fix() {

if whiptail --title "$TITLE" --yesno "Set DRM modeset for Better Wayland support?" 10 60; then
    bash "$BASE_DIR/Nvidia-FIX-DRM-modeset.sh"
    echo "Ran Nvidia-FIX-DRM-modeset.sh"
fi

if whiptail --title "$TITLE" --yesno "Set Nvidia GPU for primary display?(Reccomended for hybrid laptop graphics)" 10 60; then
    bash "$BASE_DIR/Nvidia-FIX/Nvidia-FIX-Only-Hybrid-Setup.sh"
    echo "Ran Nvidia-FIX-Only-Hybrid-Setup.sh"
fi

if whiptail --title "$TITLE" --yesno "Fix Sleep mode with Nvidia (May reboot system)" 10 60; then
    bash "$BASE_DIR/Nvidia-FIX/Nvidia-FIX-Suspend.sh"
    echo "Nvidia-FIX-Suspend.sh"
fi

if whiptail --title "$TITLE" --yesno "Fix Brighness Controll on Some laptops with Nvidia Only GPUS?" 10 60; then
    bash "$BASE_DIR/Nvidia-FIX/Nvidia-FIX-Brightness-Controll-Nvidia.sh"
    echo "Nvidia-FIX-Brightness-Controll-Nvidia.sh"
fi

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
    elif echo "$gpu_info" | grep -q " GM1\| GM2\| GP1\| GP2"; then
        echo "Detected Generation: Maxwell Or Pascal"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
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
# Detect AMD Generation
    if echo "$gpu_info" | grep -q "RV[1-5]"; then
        echo "Detected: RV100-500 series (use mesa-amber)"
        "$SCRIPT_DIR/mesa-amber.sh"
    else
        echo "Detected AMD GPU, installing for Terrascale, GCN, RDNA and UDNA."
        "$SCRIPT_DIR/amd-ati-RADV.sh"
    fi
}

install_intel() {
# Detect Intel Generation
    if echo "$gpu_info" | grep -q "Gen[1-4]"; then
        echo "Detected: Intel Gen 1–4 (use mesa-amber)"
        "$SCRIPT_DIR/mesa-amber.sh"
    elif echo "$gpu_info" | grep -q "HD Graphics\|UHD\|Iris"; then
        echo "Detected: Intel GPU Gen 5 and Newer"
        "$SCRIPT_DIR/intel-gpu-drivers.sh"
    else
        echo "Failed to Detect Intel GPU generation."
        read -p "Install standard intel drivers? Enter to install, CTRL+c to cancel"
         "$SCRIPT_DIR/intel-gpu-drivers.sh"
    fi
}

install_mesa_glhf() {
#Install mesa GLHF
    echo "Failed to Detect GPU."
    read -p "Install basic Mesa drivers? Enter to install, CTRL+c to cancel"
    sudo xbps-install -Syu mesa
    sudo xbps-install -Syu mesa-32bit #will fail on musl
}


#chek if you have dual gpus
gpu_count=$(lspci -nn | grep -Ei "vga|3d" | wc -l)
if [ "$gpu_count" -gt 1 ]; then
    echo "Multiple GPUs detected!"
    echo "You must manually select your gpu combination:"
    echo "1) AMD + Intel"
    echo "2) AMD + NVIDIA"
    echo "3) Intel + NVIDIA"
    echo "4) Only AMD"
    echo "5) Only Intel"
    echo "6) Only NVIDIA"
    read -rp "Choice: " combo
    case "$combo" in
        1) install_amd; install_intel; exit 0 ;;
        2) install_amd; install_nvidia; exit 0 ;;
        3) install_intel; install_nvidia; exit 0 ;;
        4) install_amd; exit 0 ;;
        5) install_intel; exit 0 ;;
        6) install_nvidia; exit 0 ;;
        *) echo "Invalid option. Aborting."; exit 1 ;;
    esac
fi

# Detect Vendor
if echo "$gpu_info" | grep -qi "nvidia"; then
    VENDOR="NVIDIA"
    echo -e "${GREEN}Vendor: $VENDOR${NC}"
    install_nvidia
elif echo "$gpu_info" | grep -qi " amd \| ati "; then
    VENDOR="AMD"
    echo -e "${RED}Vendor: $VENDOR${NC}"
    install_amd
elif echo "$gpu_info" | grep -qi " intel "; then
    VENDOR="Intel"
    echo -e "${BLUE}Vendor: $VENDOR${NC}"
     install_intel
else
    VENDOR="Unknown"
    install_mesa_glhf
fi
