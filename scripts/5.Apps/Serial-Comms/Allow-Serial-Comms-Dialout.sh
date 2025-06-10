#!/bin/bash
sudo usermod -aG dialout "$USER"
echo "Added you to the dialout group in order to communicate with for ex: Arduino and Chirp"
echo "Note: You will need to LOG OUT AND BACK IN for the 'dialout' group change to take effect."
echo "LOG OUT AND BACK IN!!!"
