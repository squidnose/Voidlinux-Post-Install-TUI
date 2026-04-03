#!/bin/bash
read -p "Press Enter to Clear XBPS cache, CTRL+c to cancel"
sudo xbps-remove -yO
