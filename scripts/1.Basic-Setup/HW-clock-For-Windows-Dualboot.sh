#/bin/bash
echo "This script sets the System clock to HW clock, the same as windows"
echo "Fixes time diference when dualbooting with windows"
sudo hwclock --systohc --localtime
