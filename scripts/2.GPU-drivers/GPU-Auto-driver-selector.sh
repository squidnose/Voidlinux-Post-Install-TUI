#!/bin/bash
#Colorisation
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m'

#find dir to run scripts
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

#chek if you have dual gpus
gpu_count=$(lspci -nn | grep -Ei "vga|3d" | wc -l)
if [ "$gpu_count" -gt 1 ]; then
    echo "! Multiple GPUs detected. This script may not handle hybrid graphics correctly !"
    echo "It has priority as: 1. Nvidia, 2. AMD, 3. Intel"
    read -p "Press Enter to continue, CTRL+c to cancel"
fi

#info about gpu model
gpu_info=$(lspci -nn | grep -Ei "vga|3d")

echo "Detected GPU: $gpu_info"

# Detect Vendor
if echo "$gpu_info" | grep -qi "nvidia"; then
    VENDOR="NVIDIA"
    echo -e "${GREEN}Vendor: $VENDOR${NC}"
elif echo "$gpu_info" | grep -qi " amd \| ati "; then
    VENDOR="AMD"
    echo -e "${RED}Vendor: $VENDOR${NC}"
elif echo "$gpu_info" | grep -qi " intel "; then
    VENDOR="Intel"
    echo -e "${BLUE}Vendor: $VENDOR${NC}"
else
    VENDOR="Unknown"
fi


# Detect Nvidia Generation
if [[ "$VENDOR" == "NVIDIA" ]]; then
    if echo "$gpu_info" | grep -q " GF1\| GF2"; then
        echo "Detected Generation: Fermi"
        "$SCRIPT_DIR/nvidia390-Fermi.sh"
    elif echo "$gpu_info" | grep -q " GK1\| GK2"; then
        echo "Detected Generation: Kepler"
        "$SCRIPT_DIR/nvidia470-Kepler.sh"
    elif echo "$gpu_info" | grep -q " GM1\| GM2\| GP1\| GP2"; then
        echo "Detected Generation: Maxwell Or Pascal"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
    elif echo "$gpu_info" | grep -q " TU1\| TU2"; then
        echo "Detected Generation: Turing"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
    elif echo "$gpu_info" | grep -q " GA1\| GA2"; then
        echo "Detected Generation: Ampere"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
    elif echo "$gpu_info" | grep -q " AD1\| AD2"; then
        echo "Detected Generation: Ada Lovelace"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
    elif echo "$gpu_info" | grep -q " GB1\| GB2"; then
        echo "Detected Generation: Blackwell"
        "$SCRIPT_DIR/nvidia-New-Stable.sh"
    else
        echo "You are either using a older card, or the script failed to recognize your gpu"
        read -p "Install FOSS Nouveau drivers? Enter to install, CTRL+c to cancel"
        "$SCRIPT_DIR/nvidia-Nouveau-drivers.sh"
    fi
fi

# Detect AMD Generation
if [[ "$VENDOR" == "AMD" ]]; then
    if echo "$gpu_info" | grep -q "RV[1-5]"; then
        echo "Detected: RV100-500 series (use mesa-amber)"
        "$SCRIPT_DIR/mesa-amber.sh"
    else
        echo "Detected AMD GPU, installing for Terrascale, GCN, RDNA and UDNA."
        "$SCRIPT_DIR/amd-ati-RADV.sh"
    fi
fi

# Detect Intel Generation
if [[ "$VENDOR" == "Intel" ]]; then
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
fi

#Install mesa GLHF
if [[ "$VENDOR" == "Unknown" ]]; then
    echo "Failed to Detect GPU."
    read -p "Install basic Mesa drivers? Enter to install, CTRL+c to cancel"
    sudo xbps-install -Syu mesa
    sudo xbps-install -Syu mesa-32bit #will fail on musl
fi
