#/bin/bash
CPU=$(lscpu | grep -E '^Model name:' | sed 's/Model name:\s*//')
GPU=$(lspci | grep -E "VGA|3D" | sed 's/.*: //')
WIFI=$(lspci | grep -i "network" | sed 's/.*: //')

# If using USB Wi-Fi, also check lsusb
if [ -z "$WIFI" ]; then
    WIFI=$(lsusb | grep -i "wireless\|wifi" | sed 's/.*: //')
fi

# Recommendations (basic logic example)
REC_CPU="No special CPU optimizatoins avaliable"
REC_GPU="GPU not detected use Default open-source drivers."
REC_WIFI="No special Netowrk card driver needed."

#CPU Recommendations
if echo "$CPU" | grep -qi amd; then
    REC_CPU="AMD detected - AMD kernel optimizations Reccomended"
elif echo "$CPU" | grep -qi intel; then
    REC_CPU="Intel detected - If your CPU is 10gen and older disableing Intel-Specter-Meltdown will improove perfomance at the cost of security"
fi

#GPU Recommendations
if echo "$GPU" | grep -qi nvidia; then
    REC_GPU="NVIDIA detected - proprietary driver recommended."
elif echo "$GPU" | grep -qi amd; then
    REC_GPU="AMD detected - Mesa drivers work well."
elif echo "$GPU" | grep -qi intel; then
    REC_GPU="Intel detected - Mesa drivers work well."
fi

#Network card
if echo "$WIFI" | grep -qi broadcom; then
    REC_WIFI="Broadcom detected - proprietary driver may be needed for WiFi. Ethernet cards should be ok."
elif echo "$WIFI" | grep -qi rtl8822bu; then
    REC_WIFI="Realtek RTL8822BU detected - install rtl8822bu-dkms."
elif echo "$WIFI" | grep -qi rtl8821cu; then
    REC_WIFI="Realtek RTL8821CU detected - install rtl8821cu-dkms."
elif echo "$WIFI" | grep -qi rtl8821au; then
    REC_WIFI="Realtek RTL8821AU detected - install rtl8821au-dkms."
elif echo "$WIFI" | grep -qi rtl8812au; then
    REC_WIFI="Realtek RTL8812AU detected - install rtl8812au-dkms."
fi

# 0.3 Show popup
whiptail --title "Hardware Information" --msgbox \
"CPU:  $CPU
Recommendation: $REC_CPU

GPU:  $GPU
Recommendation: $REC_GPU

Network-Card: $WIFI
Recommendation: $REC_WIFI" 20 70




