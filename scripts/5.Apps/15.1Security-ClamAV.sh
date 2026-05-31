#!/bin/bash

#Title Name
TITLE="ClamAV"

# Setup ClamAV and ClamUI(flatpak) on voidlinux

# 1. Install clamAV package
# 2. Install clamUI flatpak
# 3. Configure clamd.conf, add:
## PidFile /run/clamav/clamd.pid
## DatabaseDirectory /home/$USER/.var/app/io.github.linx_systems.ClamUI/data/clamav/
## LocalSocket /run/clamav/clamd.sock
