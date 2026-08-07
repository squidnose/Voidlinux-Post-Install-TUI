#!/bin/bash

# Makes it so you can remove the default kernel
## Usefull for if you want to free up space and or time of compilation of DKMS drivers

echo "Unsafe and Un-ready:)"
exit 0

cat > "/etc/xbps.d/ignore.conf" <<EOF
ignorepkg=linux
ignorepkg=linux-headers
EOF

sudo xbps-remove linux linux-headers
