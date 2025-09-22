#!/bin/bash
set -e

echo "Installing latest Proton-CachyOS release..."

# 1. Where Steam looks for custom Proton builds
    CHOICE=$(whiptail --title "$TITLE" --menu "Choose Steam installation type:" 20 150 2 \
        "1" "Native Steam (~/.steam/root/compatibilitytools.d)" \
        "2" "Flatpak Steam (/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d)" \
        3>&1 1>&2 2>&3) || exit 0

    case $CHOICE in
        1)
            STEAM_DIR="$HOME/.steam/root/compatibilitytools.d"
            echo "Installing to System version of steam"
            ;;
        2)
            STEAM_DIR="$HOME/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d"
            echo "Installing to flatpak version of steam"
            ;;
        *)
            echo "Invalid selection."
            exit 1
            ;;
    esac
    mkdir -p "$STEAM_DIR"
#Just in case
mkdir -p "$STEAM_DIR"

# 2. Query GitHub API for latest release assets
URLS=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest \
  | grep "browser_download_url" \
  | grep ".tar.xz" \
  | cut -d '"' -f 4)

# 3. Convert URLs into whiptail menu items
MENU_ITEMS=()
i=1
while IFS= read -r url; do
    MENU_ITEMS+=("$i" "$url")
    i=$((i+1))
done <<< "$URLS"

# 3.5 If no URLs were found
if [ ${#MENU_ITEMS[@]} -eq 0 ]; then
    echo "Could not find Proton-CachyOS download links."
    exit 1
fi

# 4. Show whiptail menu
whiptail --title "$TITLE" --msgbox "The version Numbers(V2,V3,V4) are based on how new you cpus is(X86-V2/V3/V4)\n
V1(or nothing) is fore Core 2 duo or amd CPUS with X86-64 arcitecture\n
V2 is for Intel Core i series or amd CPU with SSE4_2 instruction set\n
V3 is for intel haswell or amd Ryzen or CPU with AVX2\n
V4 is for CPUs with AVX512 instruction set" 20 150

CHOICE=$(whiptail --title "Proton-CachyOS Versions" \
  --menu "Select which Proton build to install:" 20 150 10 \
  "${MENU_ITEMS[@]}" \
  3>&1 1>&2 2>&3)

# 5. Get the selected URL
URL=$(echo "$URLS" | sed -n "${CHOICE}p")

if [ -z "$URL" ]; then
    echo "No version selected."
    exit 1
fi

echo "Downloading from: $URL"
TMPFILE=$(mktemp)
curl -L "$URL" -o "$TMPFILE"

echo "Extracting to $STEAM_DIR..."
tar -xf "$TMPFILE" -C "$STEAM_DIR"
rm "$TMPFILE"

echo "Proton-CachyOS installed. Restart Steam and check Compatibility Tools."
