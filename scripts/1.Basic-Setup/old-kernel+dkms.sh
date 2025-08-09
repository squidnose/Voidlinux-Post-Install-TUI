#!/bin/bash
echo "This script will donload the LTS linux kernel and its header for DKMS"
sudo xbps-install -Sy linux-lts linux-lts-headers
