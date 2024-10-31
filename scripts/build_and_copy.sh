#!/bin/bash

# Function to check for errors after each command
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

# Function to clean the build environment
clean() {
    echo "Cleaning build environment..."
    make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} clean
    chkerr "ERROR: Failed to clean build environment"
}

# Function to compile the kernel
compile_kernel() {
    echo "Compiling kernel..."
    make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target zImage
    chkerr "ERROR: Kernel compilation failed"
}

# Function to compile kernel modules
compile_modules() {
    echo "Compiling kernel modules..."
    make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target modules
    chkerr "ERROR: Kernel modules compilation failed"
}

# Function to install kernel modules
install_modules() {
    echo "Installing kernel modules..."
    make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra INSTALL_MOD_PATH=$KERNEL_MODULES_OUT modules_install
    chkerr "ERROR: Modules installation failed"
}

# Function to compile the device tree
compile_device_tree() {
    echo "Compiling device tree..."
    make -C kernel/kernel-4.9/ ARCH=arm64 O=$TEGRA_KERNEL_OUT LOCALVERSION=-tegra CROSS_COMPILE=${TOOLCHAIN_PREFIX} -j8 --output-sync=target dtbs
    chkerr "ERROR: Device tree compilation failed"
}

# Function to copy the compiled artifacts
copy_artifacts() {
    echo "Copying artifacts..."
    cd ${JETPACK}
    chkerr "ERROR: Failed to change directory to $JETPACK"

    # Copy kernel image
    if [ "$1" = "kernel" ] || [ "$1" = "all" ]; then
        cp -rfv $JETPACK/build/arch/arm64/boot/Image kernel/
        chkerr "ERROR: Failed to copy kernel image"
    fi

    # Copy device tree
    if [ "$1" = "dtb" ] || [ "$1" = "all" ]; then
        if ! test -e $JETPACK/build/arch/arm64/boot/dts/${DTB}; then
            cp -rfv $DTB_PATH kernel/dtb/
            chkerr "ERROR: Failed to copy device tree from DTB_PATH"
        else
            cp -rfv $JETPACK/build/arch/arm64/boot/dts/${DTB} kernel/dtb/
            chkerr "ERROR: Failed to copy device tree from build path"
        fi
    fi
    echo "Artifacts copied successfully for $1"
}

# Default to "all" if no argument is provided
TARGET="${1:-all}"

# Export Jetson Nano Jetpack utilities paths
. ./utils.sh
chkerr "ERROR: Failed to source utils.sh"

# Execute based on the argument provided
cd $TEGRA_SOURCES
chkerr "ERROR: Failed to change directory to $TEGRA_SOURCES"

case "$TARGET" in
    clean)
        clean
        ;;
    
    kernel)
        compile_kernel
        copy_artifacts "kernel"
        ;;
    
    dtb)
        compile_device_tree
        copy_artifacts "dtb"
        ;;
    
    modules)
        compile_modules
        install_modules
        copy_artifacts "modules"
        ;;
    
    all)
        compile_kernel
        compile_modules
        install_modules
        compile_device_tree
        copy_artifacts "all"
        ;;
    
    *)
        echo "Invalid argument. Usage: $0 {clear|kernel|dtb|modules|all}" >&2
        exit 1
        ;;
esac

echo "Operation completed successfully for $TARGET"
