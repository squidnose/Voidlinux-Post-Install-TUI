#!/bin/bash

gpu_count=$(lspci -nn | grep -Ei "vga|3d" | wc -l)
if [ "$gpu_count" -gt 1 ]; then
    echo "! Multiple GPUs detected. This script may not handle hybrid graphics correctly !"
    echo "It has priority as: 1. Nvidia, 2. AMD, 3. Intel"
    read -p "Press Enter to continue, CTRL+c to cancel"
fi

gpu_info=$(lspci -nn | grep -Ei "vga|3d")

echo "Detected GPU: $gpu_info"

# Detect Vendor
if echo "$gpu_info" | grep -qi "nvidia"; then
    VENDOR="NVIDIA"
elif echo "$gpu_info" | grep -qi " amd \| ati "; then
    VENDOR="AMD"
elif echo "$gpu_info" | grep -qi " intel "; then
    VENDOR="Intel"
else
    VENDOR="Unknown"
fi

echo "Vendor: $VENDOR"

# Detect Nvidia Generation
if [[ "$VENDOR" == "NVIDIA" ]]; then
    if echo "$gpu_info" | grep -q "GTX 7\|GTX 6\|GK1\|GK2"; then
        echo "Detected Generation: Kepler"
        ./nvidia470-Kepler.sh
    elif echo "$gpu_info" | grep -q "GTX 4\|GTX 5\|GTS 4\|GF1"; then
        echo "Detected Generation: Fermi"
        ./nvidia390-Fermi.sh
    elif echo "$gpu_info" | grep -q "GTX 9\|GTX 10\|GM1\|GM2\|GP1"; then
        echo "Detected Generation: Maxwell Or Pascal"
        ./nvidia-New-Stable.sh
    elif echo "$gpu_info" | grep -q "RTX 20\|GTX 16\|TU1"; then
        echo "Detected Generation: Turing"
        ./nvidia-New-Stable.sh
    elif echo "$gpu_info" | grep -q "RTX 30\|GA1"; then
        echo "Detected Generation: Ampere"
        ./nvidia-New-Stable.sh
    elif echo "$gpu_info" | grep -q "RTX 40\|AD1"; then
        echo "Detected Generation: Ada Lovelace"
        ./nvidia-New-Stable.sh
    elif echo "$gpu_info" | grep -q "RTX 50\|GB1\|GB2"; then
        echo "Detected Generation: Blackwell"
        ./nvidia-New-Stable.sh
    else
        echo "You are either using a older card, or the script failed to recognize your gpu"
        read -p "Install FOSS Nouveau drivers? Enter to install, CTRL+c to cancel"
        ./nvidia-Nouveau-drivers.sh
    fi
fi

# Detect AMD Generation
if [[ "$VENDOR" == "AMD" ]]; then
    if echo "$gpu_info" | grep -q "RV[1-5]"; then
        echo "Detected: RV100-500 series (use mesa-amber)"
        ./mesa-amber.sh
    else
        echo "Detected AMD GPU, installing for Terrascale, GCN, RDNA and UDNA."
        ./amd-ati-RADV.sh
    fi
fi

# Detect Intel Generation
if [[ "$VENDOR" == "Intel" ]]; then
    if echo "$gpu_info" | grep -q "Gen[1-4]"; then
        echo "Detected: Intel Gen 1–4 (use mesa-amber)"
        ./mesa-amber.sh
    elif echo "$gpu_info" | grep -q "HD Graphics\|UHD\|Iris"; then
        echo "Detected: Intel GPU Gen 5 and Newer"
        ./intel-gpu-drivers.sh
    else
        echo "Failed to Detect Intel GPU generation."
        read -p "Install standard intel drivers? Enter to install, CTRL+c to cancel"
        ./intel-gpu-drivers.sh
    fi
fi
#Install mesa GLHF
if [[ "$VENDOR" == "Unknown" ]]; then
    echo "Failed to Detect GPU."
    read -p "Install basic Mesa drivers? Enter to install, CTRL+c to cancel"
    sudo xbps-install -Syu mesa
    sudo xbps-install -Syu mesa-32bit #will fail on musl
fi
