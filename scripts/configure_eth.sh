#!/bin/bash

# Restart the network manager
sudo systemctl restart NetworkManager

# Reset the ethernet interface (Change enp3s0 by the corresponding one using "ip a")
sudo ip link set enp3s0 down
sudo ip link set enp3s0 up

# Configure you ip address manually through the config panel


