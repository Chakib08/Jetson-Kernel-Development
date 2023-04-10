#!/bin/bash

CROSS_COMPILE_PATH=$HOME/l4t-gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/


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

