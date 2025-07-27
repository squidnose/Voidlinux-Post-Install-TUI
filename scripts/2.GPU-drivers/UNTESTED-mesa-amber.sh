#!/bin/bash
git clone https://gitlab.freedesktop.org/mesa/mesa.git
cd mesa-amber
mkdir build-amber
meson setup .. -Damber=true
ninja -C .  
sudo ninja -C . install

