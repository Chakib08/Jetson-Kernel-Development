#!/bin/bash

# Export jetson nano jetpack utils paths
. ./utils.sh

# Flash the DTB
cd ${JETPACK}
sudo ./flash.sh jetson-nano-qspi-sd mmcblk0p1