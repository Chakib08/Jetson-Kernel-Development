# Jetson-Kernel-Development
Jetson environment for kernel modules development

**Table Of Contents**
- [Description](#description)
- [Enviroment](#enviroment)
- [How does this sample work?](#how-does-this-sample-work)
- [Prerequisites](#prerequisites)
- [Running the sample](#running-the-sample)
- [Additional resources](#additional-resources)
- [Changelog](#changelog)
- [Known issues](#known-issues)
- [Details](#Details)

## Description
The Jetson Kernel Development environment allows you to build linux-tegra kernel through shell scripts by cross-compiling a monolithic kernel image with drivers as built-in, cross-compiling modules as kernel objects and load them to your image and compiling the board device tree.

## Enviroment
This environment was tested with
- [x] PC Ubuntu 20.04 OS
- [x] NVIDIA Jetson Nano Development Kit 

## Prerequisites
Run in a terminal the script below to install the environment requirements

`cd $HOME/Jetson-Kernel-Development/`

`sh install_requirements.sh` 


## How to build and customize the kernel

### Configure the kernel
Genereate the .config file by running

`chmod a+x defconfig.sh`

`./defconfig.sh`

Apply your changes by disabling [] / enabling [*] drivers or mark the loadable modules [M]

`chmod a+x menu_config.sh`

`./menu_config.sh`

A GUI will be opened in your terminal

![Menuconfig image](doc/imgs/menuconfig.png)

You can browse through the menuconfig consol to see all the available drivers, you can find below nvidia overlays encoders, decoders and image sensor drivers

![Menuconfig image](doc/imgs/menuconfig_nvidia_overlay.png)



### Build kernel


