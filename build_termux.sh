#!/data/data/com.termux/files/usr/bin/bash
set -e

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SRC_DIR/build-termux"

echo "=== Đang cấu hình và biên dịch SDL3 cho Termux (X11 / Wayland) ==="

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake "$SRC_DIR" \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SHARED_LINKER_FLAGS="-landroid-shmem" \
    -DCMAKE_EXE_LINKER_FLAGS="-landroid-shmem" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DSDL_STATIC=ON \
    -DSDL_SHARED=ON \
    -DSDL_TESTS=OFF \
    -DSDL_INSTALL_TESTS=OFF \
    -DSDL_X11=ON \
    -DSDL_WAYLAND=ON \
    -DSDL_PULSEAUDIO=ON \
    -DSDL_OPENGL=ON \
    -DSDL_OPENGLES=ON \
    -DSDL_VULKAN=ON \
    -GNinja

ninja -j$(nproc)
ninja install

echo "=== Hoàn tất cài đặt SDL3 vào hệ thống Termux ($PREFIX)! ==="
