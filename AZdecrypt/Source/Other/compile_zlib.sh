#!/bin/sh
#
# How to use msys2 to build an optimized static zlib.a
#
#
# 1. Install MSYS2 from msys2.org
# 2. pacman -Syu --noconfirm
# 3. Restart MSYS2 UCRT64
# 4. cd /c/azdecrypt/AZdecrypt/Source/Other/
# 5. ./compile_zlib.sh
#

pacman -Syu --needed --noconfirm base-devel mingw-w64-ucrt-x86_64-toolchain cmake git

git clone https://github.com/zlib-ng/zlib-ng
cd zlib-ng; cmake -DZLIB_COMPAT=ON -DWITH_GTEST=OFF -DZLIB_ENABLE_TESTS=OFF .; cmake --build . --config Release; mv libz.a ../../AZdecrypt/; cd ..; rm -rf zlib-ng