#!/bin/bash

# Export jetson nano jetpack utils paths
. ./utils.sh

# Variable to trace errors
ERR=0

# Linux4Tegra sources version is 32.7.3 by default
if [ -z $1 ]
then
    L4T_VERSION=32.7.3
else
    L4T_VERSION=$1
fi

# Download GCC Linaro toolchain to cross-compile Jetson's image
if ! test -e $CROSS_COMPILE_PATH;
then
    echo "Dowloading GCC Linaro toolchain..."
    mkdir -p $HOME/l4t-gcc
    cd $HOME/l4t-gcc
    wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
    tar xfv gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
else
    echo "GCC Linaro toolchain already downloaded, skipping..."
fi

# Download Tegra sources
if ! test -e $TEGRA_SOURCES
then
    cd $JETPACK
    echo "Downloading TEGRA sources from tag tegra-l4t-r$L4T_VERSION"
    ./source_sync.sh -t tegra-l4t-r$L4T_VERSION
else
    echo "TEGRA from tag tegra-l4t-r$L4T_VERSION sources already dowloaded, skipping..."
fi

# Check if requirements were installed successfully
ERR=$?
if [ $ERR -eq 0 ] 
then
    echo "All requirements were installed successfully"
else
    echo "ERROR: One or more packages couldn't be installed"
fi