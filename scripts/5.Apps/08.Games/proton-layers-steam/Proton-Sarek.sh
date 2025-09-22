#!/bin/bash
set -e

echo "Installing latest Proton-Sarek release..."

# Where Steam looks for custom Proton builds
STEAM_DIR="$HOME/.steam/root/compatibilitytools.d"
mkdir -p "$STEAM_DIR"

# Query GitHub API for latest release assets
URLS=$(curl -s https://api.github.com/repos/pythonlover02/Proton-Sarek/releases/latest \
  | grep "browser_download_url" \
  | grep ".tar.gz" \
  | cut -d '"' -f 4)

# Convert URLs into whiptail menu items
MENU_ITEMS=()
i=1
while IFS= read -r url; do
    MENU_ITEMS+=("$i" "$url")
    i=$((i+1))
done <<< "$URLS"

# If no URLs were found
if [ ${#MENU_ITEMS[@]} -eq 0 ]; then
    echo "Could not find Proton-Sarek download links."
    exit 1
fi

# Show whiptail menu
whiptail --title "Proton-Sarek Info" --msgbox "There are 2 synch options:\n
Async   | Enables asynchronous pipeline compilation. This allows shaders to be compiled in the background.\n
Non-Async | Standard build without async compilation.\n " 20 100


CHOICE=$(whiptail --title "Proton-Sarek Versions" \
  --menu "Select which Proton build to install:" 20 150 10 \
  "${MENU_ITEMS[@]}" \
  3>&1 1>&2 2>&3)

# Get the selected URL
URL=$(echo "$URLS" | sed -n "${CHOICE}p")

if [ -z "$URL" ]; then
    echo " No version selected."
    exit 1
fi

echo "Downloading from: $URL"
TMPFILE=$(mktemp)
curl -L "$URL" -o "$TMPFILE"

echo "Extracting to $STEAM_DIR..."
tar -xvf "$TMPFILE" -C "$STEAM_DIR"
rm "$TMPFILE"

echo "Proton-Sarek installed. Restart Steam and check Compatibility Tools."
