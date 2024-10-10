#!/bin/bash

# Export jetson nano jetpack utils paths
. ./utils.sh

ERR=$?

# Compile kernel and DTB
cd $TEGRA_SOURCES
# Generate .config file that contains kernel configuration
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} tegra_defconfig