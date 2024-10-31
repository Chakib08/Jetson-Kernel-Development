#!/bin/bash

chkerr () {
    if [ $? -ne 0 ]; then
        if [ "$1" != "" ]; then
            echo "$1" >&2
        else
            echo "failed." >&2
        fi
        exit 1
    fi
    if [ "$1" = "" ]; then
        echo "done."
    fi
}

# Export jetson nano jetpack utils paths
echo "Source environment..."
. ./utils.sh
chkerr "ERROR: Failed to source utils.sh"
echo "Source environment done"


# Compile kernel and DTB
cd $TEGRA_SOURCES
# Generate .config file that contains kernel configuration
# make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} tegra_defconfig

# Compile the kernel to generate Jetson's Image
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target zImage
chkerr "ERROR: Kernel compilation failed"

# Compile kernel modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target modules
chkerr "ERROR: Kernel modules compilation failed"

# Compile the device tree
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target dtbs
# TODO: See why there is compilation error while compiling hardware/nvidia/platform/t19x/galen-industrial/kernel-dts/tegra194-p2888-0008-e3366-1199.dts
#chkerr "ERROR: Device tree compilation failed"

# Install modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra INSTALL_MOD_PATH=$KERNEL_MODULES_OUT modules_install
chkerr "ERROR: Modules installation failed"

# Copy kernel, device tree and modules into jetpack
cd ${JETPACK}
# Make a copy of the rootfs
#cp -rfv rootfs/ rootfs_orig/

# Copy kernel generated
cp -rfv $JETPACK/build/arch/arm64/boot/Image kernel/
chkerr "ERROR: Failed to copy kernel image"

# Copy device tree generated
if ! test -e $JETPACK/build/arch/arm64/boot/dts/${DTB}; then
    cp -rfv $DTB_PATH kernel/dtb/
    chkerr "ERROR: Failed to copy device tree from DTB_PATH"
else
    cp -rfv $JETPACK/build/arch/arm64/boot/dts/${DTB} kernel/dtb/
    chkerr "ERROR: Failed to copy device tree from build path"
fi
echo "Image and DTB were copied successfully"
