#!/data/data/com.termux/files/usr/bin/bash

export DISPLAY=:0
export SDL_VIDEO_DRIVER=x11
export PULSE_SERVER=127.0.0.1

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Biên dịch test_sdl nếu chưa có file binary
if [ ! -f "$DIR/test_sdl" ]; then
    echo "[*] Đang biên dịch test_sdl..."
    clang -O2 "$DIR/test_sdl.c" $(pkg-config --cflags --libs sdl3) -landroid-shmem -o "$DIR/test_sdl"
fi

echo "================================================="
echo "       TERMUX-X11 SDL3 DEMO LAUNCHER"
echo "================================================="

if ! xdpyinfo -display :0 >/dev/null 2>&1; then
    echo "[!] Server X11 chưa sẵn sàng. Đang dọn dẹp socket cũ và khởi chạy..."
    rm -f /data/data/com.termux/files/usr/tmp/.X11-unix/X0 /data/data/com.termux/files/usr/tmp/.X0-lock 2>/dev/null
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1 || true
    nohup termux-x11 :0 -ac >/dev/null 2>&1 &

    count=0
    while ! xdpyinfo -display :0 >/dev/null 2>&1 && [ $count -lt 10 ]; do
        sleep 0.5
        count=$((count + 1))
    done
fi

if ! xdpyinfo -display :0 >/dev/null 2>&1; then
    echo "[LỖI] Không thể kết nối tới X11 Server (:0)!"
    echo "Hãy chắc chắn rằng bạn đã mở app Termux-X11 trên điện thoại."
    exit 1
fi

echo "[✓] X11 Server (:0) đang hoạt động!"
echo "[*] Vui lòng chuyển sang app Termux-X11 để xem đồ họa (nhấn Q để thoát)."

"$DIR/test_sdl"
