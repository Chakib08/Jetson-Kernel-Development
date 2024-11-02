#!/bin/bash

if [ -z $1 ]
then
    JETSON_PROFILE="jetson"
    echo "Using default jetson profile is : $JETSON_PROFILE"
else
    JETSON_PROFILE=$1
    echo "Using jetson profile is : $JETSON_PROFILE"
fi

# Export Jetson Nano JetPack utils paths
. ./utils.sh

# Prompt the user for the password securely
echo "Enter your password for sudo and SSH:"
read -s PASSWORD

# Copy kernel Image and dtb to Jetson via SCP
sshpass -p "$PASSWORD" scp "$JETPACK/kernel/Image" JETSON_PROFILE@192.168.55.1:/home/JETSON_PROFILE/

if [ $? -eq 0 ]; then
    echo "Image copied from host to Jetson"
else
    echo "Password is incorrect."
    exit 1
fi

sshpass -p "$PASSWORD" scp "$JETPACK/kernel/dtb/$DTB" JETSON_PROFILE@192.168.55.1:/home/JETSON_PROFILE/
echo "DTB copied from host to Jetson"

# Display instructions for manual commands
echo "Run on Jetson Nano:"
echo "sudo cp Image /boot/"
echo "sudo cp tegra210-p3448-0000-p3449-0000-b00.dtb /boot/dtb/"

# SSH into Jetson with the provided password
sshpass -p "$PASSWORD" ssh JETSON_PROFILE@192.168.55.1
