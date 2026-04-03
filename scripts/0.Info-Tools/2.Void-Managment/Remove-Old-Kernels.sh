#!/bin/bash
echo "searching old unused kernels"
vkpurge list

read -p "Remove all listed kernels?, Enter to continue, CTRL+c to cancel"
sudo vkpurge rm all
