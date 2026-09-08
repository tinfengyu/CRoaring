#!/usr/bin/env bash
set -e

BUILD_DIR="build-riscv"

# 如果传入 clean，就删除旧构建目录
if [ "$1" = "clean" ]; then
    echo "Cleaning ${BUILD_DIR}..."
    rm -rf "${BUILD_DIR}"
fi

if [ ! -f "${BUILD_DIR}/CMakeCache.txt" ]; then
 
   echo "Configuring RISC-V RVV build..."

   cmake -S . -B "${BUILD_DIR}" \
       -DCMAKE_SYSTEM_NAME=Linux \
       -DCMAKE_SYSTEM_PROCESSOR=riscv64 \
       -DCMAKE_C_COMPILER=riscv64-linux-gnu-gcc \
       -DCMAKE_CXX_COMPILER=riscv64-linux-gnu-g++ \
       -DCMAKE_C_FLAGS="-march=rv64gcv" \
       -DCMAKE_CXX_FLAGS="-march=rv64gcv" \
       -DCMAKE_CROSSCOMPILING_EMULATOR:STRING="qemu-riscv64;-L;/usr/riscv64-linux-gnu;-cpu;rv64,v=true,vlen=256" 
fi
echo "Building..."

cmake --build "${BUILD_DIR}" -j"$(nproc)"

echo "Build finished."
