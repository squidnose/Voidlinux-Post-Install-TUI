#!/bin/bash

# 1. Dependencies
## Basic
sudo xbps-install -Syu fprintd

## Build Dependencies
sudo xbps-install -Syu base-devel git meson ninja pkg-config glib-devel libgusb-devel libgudev-devel nss-devel pixman-devel libopencv-devel doctest

# 2. Download
mkdir ~/Git
cd ~/Git
git clone https://github.com/archeYR/libfprint-CS9711.git
cd libfprint-CS9711


# 3. Prepare
sudo mkdir -p /usr/share/pkgconfig
cat <<EOF | sudo tee /usr/share/pkgconfig/doctest.pc
prefix=/usr
includedir=\${prefix}/include
Name: doctest
Description: Header-only C++ test framework
Version: 2.4.11
Cflags: -I\${includedir}/doctest
EOF

export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH

# 4. Compile
meson setup build --prefix=/usr
ninja -C build

# 5. Install
sudo ninja -C build install

# 6. Setup
sudo ldconfig
sudo killall fprintd
fprintd-enroll # Enrolls fingerprint


