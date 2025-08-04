#!/bin/bash

get_usb_standard() {
  case "$1" in
    1.5) echo "USB 1.0 (Low Speed)";;
    12) echo "USB 1.1 (Full Speed)";;
    480) echo "USB 2.0 (High Speed)";;
    5000) echo "USB 3.0 / 3.1 Gen 1 / 3.2 Gen 1x1";;
    10000) echo "USB 3.1 Gen 2 / 3.2 Gen 2x1";;
    20000) echo "USB 3.2 Gen 2x2";;
    40000) echo "USB4 Gen 3x2";;
    *) echo "Unknown";;
  esac
}

declare -A name_map
while read -r line; do
  bus=$(echo "$line" | awk '{print $2}')
  dev=$(echo "$line" | awk '{print $4}' | tr -d ':')
  name=$(echo "$line" | cut -d ' ' -f7-)
  key="$bus:$dev"
  name_map["$key"]="$name"
done < <(lsusb)

# Increased name column from 40 → 60 characters
printf "%-6s %-4s %-60s %-10s %-30s\n" "Bus" "Dev" "Device Name" "Speed" "USB Standard"
printf "%0.s-" {1..120}; echo

current_bus=""
while read -r line; do
  if [[ "$line" =~ Bus\ ([0-9]+)\. ]]; then
    current_bus="${BASH_REMATCH[1]}"
  fi

  if [[ "$line" =~ Dev\ ([0-9]+),.*\ ([0-9]+)M ]]; then
    dev="${BASH_REMATCH[1]}"
    speed="${BASH_REMATCH[2]}"
    key="${current_bus}:${dev}"
    name="${name_map[$key]:-Unknown}"
    standard=$(get_usb_standard "$speed")
    printf "%-6s %-4s %-60s %-10s %-30s\n" "$current_bus" "$dev" "$name" "${speed}M" "$standard"
  fi
done < <(lsusb -t)
