#!/bin/bash
# Get recommendations based on detected hardware
#============================ Detect Hardware ============================
### Get CPU model
CPU=$(lscpu | grep -E '^Model name:' | sed 's/Model name:\s*//')

### Get ALL GPUs
GPUS=$(lspci | grep -E "VGA|3D" | sed 's/.*: //')

### PCIe network devices
NETWORK_PCIE=$(lspci | grep -i "network\|wireless\|wifi" | sed 's/.*: //')

### USB network devices
NETWORK_USB=$(lsusb | grep -i "network\|wireless\|wifi" | sed 's/.*: //')

### Combine ALL network devices
NETWORK_ALL="$NETWORK_PCIE"$'\n'"$NETWORK_USB"

#============================ Recommendation Storage ============================
RECOMMENDATIONS=()

#============================ CPU Recommendations ============================
if echo "$CPU" | grep -qi amd; then
    RECOMMENDATIONS+=("CPU - $CPU: \nIf your CPU is 1.gen Ryzen (Zen) and older, consider mitigations=off as boot parameter. This may improve performance at the cost of security")
elif echo "$CPU" | grep -qi intel; then
    RECOMMENDATIONS+=("CPU - $CPU: \nIf your CPU 7.gen (Kaby Lake) and older, consider mitigations=off as boot parameter. This may improve performance at the cost of security")
fi

#============================ GPU Recommendations ============================

while read -r gpu_info; do
    [ -z "$gpu_info" ] && continue

    if echo "$gpu_info" | grep -qi nvidia; then
        # Detect Nvidia generation
        if echo "$gpu_info" | grep -q " GF1\| GF2"; then
            RECOMMENDATIONS+=("GPU - $gpu_info: \nUse NVIDIA 390 + Linux 6.1.")
        elif echo "$gpu_info" | grep -q " GK1\| GK2"; then
            RECOMMENDATIONS+=("GPU - $gpu_info: \nUse NVIDIA 470 + Linux 6.6.")
        elif echo "$gpu_info" | grep -q " GM\| GP\| TU"; then
            RECOMMENDATIONS+=("GPU - $gpu_info: \nUse NVIDIA 580 driver.")
        elif echo "$gpu_info" | grep -q " GA\| AD\| GB"; then
            RECOMMENDATIONS+=("GPU - $gpu_info: \nUse latest NVIDIA driver.")
        else
            RECOMMENDATIONS+=("GPU - $gpu_info: \nOlder GPU, use Mesa drivers.")
        fi

    elif echo "$gpu_info" | grep -qi amd; then
        RECOMMENDATIONS+=("GPU - $gpu_info: \nMesa drivers recommended.")

    elif echo "$gpu_info" | grep -qi intel; then
        RECOMMENDATIONS+=("GPU - $gpu_info: \nMesa drivers recommended.")

        ### Detect current kernel driver (i915 or xe)
        CURRENT_DRIVER=$(lspci -k | grep -A2 -E "VGA|3D" | grep "Kernel driver in use" | head -n1 | awk '{print $5}')

        ### If Xe-capable GPU but still using i915
        if echo "$gpu_info" | grep -qi "Xe"; then
            if [ "$CURRENT_DRIVER" = "i915" ]; then
                RECOMMENDATIONS+=("GPU - $gpu_info: \nIntel Xe GPU detected but using i915. You can try experimental 'xe' driver(Linux6.8+).")
            elif [ "$CURRENT_DRIVER" = "xe" ]; then
                RECOMMENDATIONS+=("GPU - $gpu_info: \nIntel Xe driver is already in use.")
            fi
        fi
    else
        RECOMMENDATIONS+=("GPU - $gpu_info: \nUnknown GPU, try Mesa drivers.")
    fi

done <<< "$GPUS"

#============================ Network Recommendations ============================
while read -r net; do
    [ -z "$net" ] && continue

    if echo "$net" | grep -qi broadcom; then
        RECOMMENDATIONS+=("Network - $net: \nBroadcom may require proprietary drivers.")
    elif echo "$net" | grep -qi rtl8822bu; then
        RECOMMENDATIONS+=("Network - $net: \nInstall rtl8822bu-dkms.")
    elif echo "$net" | grep -qi rtl8821cu; then
        RECOMMENDATIONS+=("Network - $net: \nInstall rtl8821cu-dkms.")
    elif echo "$net" | grep -qi rtl8821au; then
        RECOMMENDATIONS+=("Network - $net: \nInstall rtl8821au-dkms.")
    elif echo "$net" | grep -qi rtl8812au; then
        RECOMMENDATIONS+=("Network - $net: \nInstall rtl8812au-dkms.")
    else
        RECOMMENDATIONS+=("Network - $net: \nNo special driver needed.")
    fi

done <<< "$NETWORK_ALL"


#============================ Build Output ============================
for rec in "${RECOMMENDATIONS[@]}"; do
    OUTPUT+="$rec\n\n"
done

#============================ Display ============================

whiptail --title "Hardware Recommendations" \
--msgbox "$OUTPUT" 25 80
