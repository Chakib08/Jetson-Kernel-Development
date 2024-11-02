#!/bin/bash
echo "Source Jetson Kernel Development environment..."

export CROSS_COMPILE_PATH=$HOME/l4t-gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/
export JETPACK_PARENT=$HOME/nvidia/nvidia_sdk/JetPack_4.6.3_Linux_JETSON_NANO_TARGETS
export JETPACK=$JETPACK_PARENT/Linux_for_Tegra
export BSP=$HOME/Linux_for_Tegra
export BSP_ARCHIVE=jetson-210_linux_r32.7.1_aarch64.tbz2
export BSP_ARCHIVE_LINK=https://developer.nvidia.com/embedded/l4t/r32_release_v7.1/t210/jetson-210_linux_r32.7.1_aarch64.tbz2
export ROOFTS_ARCHIVE=tegra_linux_sample-root-filesystem_r32.7.1_aarch64.tbz2
export ROOFTS_LINK=https://developer.nvidia.com/embedded/l4t/r32_release_v7.1/t210/tegra_linux_sample-root-filesystem_r32.7.1_aarch64.tbz2
export ROOTFS=$HOME/nvidia/nvidia_sdk/JetPack_4.6.3_Linux_JETSON_NANO_TARGETS/Linux_for_Tegra/rootfs
export TEGRA_SOURCES=$JETPACK/sources/
export TOOLCHAIN_PREFIX=$CROSS_COMPILE_PATH/bin/aarch64-linux-gnu-
export TEGRA_KERNEL_OUT=$JETPACK/build
export KERNEL_MODULES_OUT=$JETPACK/modules
export DTB=tegra210-p3448-0000-p3449-0000-b00.dtb
export DTB_PATH=$JETPACK/build/arch/arm64/boot/dts/_ddot_/_ddot_/_ddot_/_ddot_/_ddot_/_ddot_/hardware/nvidia/platform/t210/porg/kernel-dts/tegra210-p3448-0000-p3449-0000-b00.dtb

ERR=$?
if [ $ERR -ne 0 ]; then
    echo "ERROR: Source environment failed" >&2
    exit $ERR
fi

echo "Source environment success"