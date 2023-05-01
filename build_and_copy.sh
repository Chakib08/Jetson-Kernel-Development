#!/bin/bash

# Export jetson nano jetpack utils paths
. ./utils.sh

ERR=$?

# Compile kernel and DTB
cd $TEGRA_SOURCES
# Generate .config file that contains kernel configuration
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} tegra_defconfig
# Compile the kernel to generate Jetson's Image
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target zImage
# Compile kernel modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target modules
# Compile the device tree
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target dtbs
# Install modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra INSTALL_MOD_PATH=$KERNEL_MODULES_OUT modules_install

ERR=$?

# Check if Image and DTB were compiled
if [ $ERR -eq 0 ] 
then
    echo "Image and DTB were compiled successfully"
else
    echo "ERROR: Image and DTB compilation failed"
    exit $ERR
fi

# Copy kernel, device tree and modules into jetpack
cd ${JETPACK}
# Make a copy of the rootfs
#cp -rfv rootfs/ rootfs_orig/
# Copy kernel generated
cp -rfv $JETPACK/build/arch/arm64/boot/Image kernel/
# Copy device tree generated
if ! test -e $JETPACK/build/arch/arm64/boot/dts/${DTB}; then
    cp -rfv $DTB_PATH kernel/dtb/
else
    cp -rfv $JETPACK/build/arch/arm64/boot/dts/${DTB} kernel/dtb/
fi

if [ $ERR -eq 0 ] 
then
    echo "Image and DTB were copied successfully"
else
    echo "ERROR: Image and DTB copie failed"
    exit $ERR
fi
