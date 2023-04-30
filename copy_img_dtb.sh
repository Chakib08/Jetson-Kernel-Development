#!/bin/bash

# Export jetson nano jetpack utils paths
. ./utils.sh

scp $JETPACK/kernel/Image jetson@192.168.55.1:/home/jetson/
scp $JETPACK/kernel/dtb/$DTB jetson@192.168.55.1:/home/jetson/

echo "Run in jetson"
echo "sudo cp Image /boot/"
echo "sudo cp tegra210-p3448-0000-p3449-0000-b00.dtb /boot/dtb/"
ssh jetson@192.168.55.1

