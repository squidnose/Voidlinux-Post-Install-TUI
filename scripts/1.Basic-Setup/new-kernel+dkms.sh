#!/bin/bash
echo "This script will donload the newest mainline linux kernel and its header for DKMS"
sudo xbps-install -Sy linux-mainline linux-mainline-headers 
