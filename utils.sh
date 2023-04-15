#!/bin/bash

export CROSS_COMPILE_PATH=$HOME/l4t-gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/
export JETPACK=$HOME/nvidia/nvidia_sdk/JetPack_4.6.3_Linux_JETSON_NANO_TARGETS/Linux_for_Tegra/
export TEGRA_SOURCES=$JETPACK/sources/
export TOOLCHAIN_PREFIX=$CROSS_COMPILE_PATH/bin/aarch64-linux-gnu-
export TEGRA_KERNEL_OUT=$JETPACK/build
export KERNEL_MODULES_OUT=$JETPACK/modules
export DTB=tegra210-p3448-0000-p3449-0000-a02.dtb