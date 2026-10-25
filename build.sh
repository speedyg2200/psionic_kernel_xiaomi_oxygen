#!/bin/bash

set -e

# Define directories
TOOLCHAIN_DIR="$HOME/toolchains/android-kernel-tools"
PARENT_DIR="$HOME/toolchains"
OUTPUT_DIR="$HOME/build-oxygen"

if [ ! -d "$TOOLCHAIN_DIR" ]; then
    echo "Toolchain not found at $TOOLCHAIN_DIR. Downloading Clang 13 + GCC 4.9..."
    mkdir -p "$PARENT_DIR"
    git clone --depth=1 https://github.com/prabhatkrmishra/android-kernel-tools.git "$TOOLCHAIN_DIR"
else
    echo "Toolchain found at $TOOLCHAIN_DIR."
fi

export PATH="$HOME/toolchains/android-kernel-tools/clang/host/linux-x86/clang-r428724/bin:$HOME/toolchains/android-kernel-tools/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$HOME/toolchains/android-kernel-tools/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/toolchains/android-kernel-tools/clang/host/linux-x86/clang-r428724/lib64:$LD_LIBRARY_PATH"

echo "Making defconfig..."
make O="$OUTPUT_DIR" \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    HOSTCC=gcc \
    HOSTCXX=g++ \
    oxygen_defconfig

echo "Building kernel..."
make O="$OUTPUT_DIR" \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    HOSTCC=gcc \
    HOSTCXX=g++ \
    Image.gz-dtb -j$(nproc)

echo "Kernel built successfully at ~/build-oxygen/arch/arm64/Image.gz-dtb"
