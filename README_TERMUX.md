# SDL3 for Termux & Android

Bản phân phối mã nguồn **SDL3** được tối ưu hóa đặc biệt để:
1. **Biên dịch và chạy trực tiếp trên Android qua Termux** với hỗ trợ xuất hình qua **Termux-X11** hoặc **Wayland**.
2. **Đóng gói thành ứng dụng Android APK** thông qua **Android NDK** (sử dụng `android-project`).

---

## 1. Yêu cầu cài đặt trên Termux

Trước khi biên dịch, hãy đảm bảo các gói sau đã được cài đặt trên Termux:

```bash
pkg update
pkg install x11-repo
pkg install clang cmake ninja git pkg-config \
    libx11 libxcursor libxext libxfixes libxi libxinerama libxkbcommon libxrandr libxss \
    libandroid-shmem mesa pulseaudio termux-x11-nightly
```

---

## 2. Biên dịch và cài đặt SDL3 trên Termux

Chỉ cần chạy script:

```bash
chmod +x build_termux.sh
./build_termux.sh
```

Script sẽ tự động:
* Cấu hình CMake với các cờ tối ưu cho Termux (`-DCMAKE_SYSTEM_NAME=Linux`, `-landroid-shmem`).
* Kích hoạt đầy đủ các driver: **X11**, **Wayland**, **OpenGL**, **OpenGLES 2**, **Vulkan**, **PulseAudio**.
* Biên dịch cả thư viện chia sẻ (`libSDL3.so`) và thư viện tĩnh (`libSDL3.a`).
* Cài đặt trực tiếp vào hệ thống Termux (`$PREFIX`).

---

## 3. Chạy Demo trên Termux-X11

1. Cài đặt và mở ứng dụng **Termux-X11** trên Android.
2. Chạy file demo có sẵn trong thư mục `examples`:
   ```bash
   chmod +x examples/run_demo.sh
   ./examples/run_demo.sh
   ```
3. Chuyển sang màn hình ứng dụng **Termux-X11** để xem cửa sổ đồ họa hoạt họa 60 FPS. Nhấn **Q** hoặc **ESC** để thoát.

---

## 4. Biên dịch dự án C/C++ của bạn

Để biên dịch một chương trình C/C++ sử dụng SDL3:

```bash
clang -O2 main.c $(pkg-config --cflags --libs sdl3) -landroid-shmem -o my_app
```

Khi chạy hiển thị trên Termux-X11:
```bash
DISPLAY=:0 SDL_VIDEO_DRIVER=x11 ./my_app
```

---

## 5. Đóng gói thành APK (Android NDK)

Mã nguồn vẫn giữ nguyên thư mục `android-project/` tiêu chuẩn của SDL3.

Khi bạn muốn đóng gói thành APK:
1. Đưa mã nguồn về trạng thái gốc dành cho Android NDK:
   ```bash
   git checkout release-3.4.20
   ```
2. Thư mục `android-project/` có thể được mở bằng Android Studio hoặc biên dịch bằng Gradle + Android NDK:
   ```bash
   cd android-project
   ./gradlew assembleDebug
   ```
   File APK sẽ được tạo tại `android-project/app/build/outputs/apk/debug/app-debug.apk`.
