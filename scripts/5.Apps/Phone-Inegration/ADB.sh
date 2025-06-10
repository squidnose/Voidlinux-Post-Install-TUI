#/bin/bash
sudo xbps-install -y android-tools android-file-transfer-linux-cli android-file-transfer-linux
echo "If you use ufw you may need to add yourself to the dialout group:"
echo "sudo usermod -aG dialout $USER"


