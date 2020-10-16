#!/usr/bin/env bash
set -eo pipefail

RUSTLIB="../../rust-lib"

cargo build --manifest-path $RUSTLIB/Cargo.toml

# Update this line accordingly if you are not building *from* x86_64
export PATH=$PATH:$NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin

CC="aarch64-linux-android21-clang" CFLAGS="--sysroot=$NDK_HOME/sysroot -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/aarch64-linux-android" CXX="aarch64-linux-android21-clang++" CXXFLAGS="$CFLAGS -nostdlib++ -I$NDK_HOME/sources/cxx-stl/llvm-libc++/include" LDFLAGS="--sysroot=$NDK_HOME/platforms/android-21/arch-arm64" cargo build --manifest-path $RUSTLIB/Cargo.toml --target=aarch64-linux-android
CC="x86_64-linux-android21-clang" CFLAGS="--sysroot=$NDK_HOME/sysroot -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/x86_64-linux-android" CXX="x86_64-linux-android21-clang++" CXXFLAGS="$CFLAGS -nostdlib++ -I$NDK_HOME/sources/cxx-stl/llvm-libc++/include" LDFLAGS="--sysroot=$NDK_HOME/platforms/android-21/arch-x86_64" cargo build --manifest-path $RUSTLIB/Cargo.toml --target=x86_64-linux-android
CC="armv7a-linux-androideabi21-clang" CFLAGS="--sysroot=$NDK_HOME/sysroot -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/arm-linux-androideabi" CXX="armv7a-linux-androideabi21-clang++" CXXFLAGS="$CFLAGS -nostdlib++ -I$NDK_HOME/sources/cxx-stl/llvm-libc++/include" LDFLAGS="--sysroot=$NDK_HOME/platforms/android-21/arch-arm -L$NDK_HOME/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a" cargo build --manifest-path $RUSTLIB/Cargo.toml --target=armv7-linux-androideabi
CC="i686-linux-android21-clang" CFLAGS="--sysroot=$NDK_HOME/sysroot -I$NDK_HOME/sysroot/usr/include -I$NDK_HOME/sysroot/usr/include/i686-linux-android" CXX="i686-linux-android21-clang++" CXXFLAGS="$CFLAGS -nostdlib++ -I$NDK_HOME/sources/cxx-stl/llvm-libc++/include" LDFLAGS="--sysroot=$NDK_HOME/platforms/android-21/arch-x86" cargo build --manifest-path $RUSTLIB/Cargo.toml --target=i686-linux-android

JNILIBS="library/src/main/jniLibs"

mkdir -pv library/src/main/java/org/lnpbp/rgbnode_autogen
swig -java -c++ -package "org.lnpbp.rgbnode_autogen" -outdir library/src/main/java/org/lnpbp/rgbnode_autogen swig.i

mkdir -p $JNILIBS/arm64-v8a $JNILIBS/x86_64 $JNILIBS/armeabi-v7a $JNILIBS/x86

aarch64-linux-android21-clang++ -shared swig_wrap.cxx -L$RUSTLIB/target/aarch64-linux-android/debug/ -o $JNILIBS/arm64-v8a/librgb.so -fPIC
cp -v $RUSTLIB/target/aarch64-linux-android/debug/librgb.so $JNILIBS/arm64-v8a/
cp -v $NDK_HOME/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/libc++_shared.so $JNILIBS/arm64-v8a/

x86_64-linux-android21-clang++ -shared swig_wrap.cxx -L$RUSTLIB/target/x86_64-linux-android/debug/ -o $JNILIBS/x86_64/librgb.so -fPIC
cp -v $RUSTLIB/target/x86_64-linux-android/debug/librgb.so $JNILIBS/x86_64/
cp -v $NDK_HOME/sources/cxx-stl/llvm-libc++/libs/x86_64/libc++_shared.so $JNILIBS/x86_64/

armv7a-linux-androideabi21-clang++ -shared swig_wrap.cxx -L$RUSTLIB/target/armv7-linux-androideabi/debug/ -o $JNILIBS/armeabi-v7a/librgb_node.so -fPIC
cp -v $RUSTLIB/target/armv7-linux-androideabi/debug/librgb.so $JNILIBS/armeabi-v7a/
cp -v $NDK_HOME/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so $JNILIBS/armeabi-v7a/

i686-linux-android21-clang++ -shared swig_wrap.cxx -L$RUSTLIB/target/i686-linux-android/debug/ -o $JNILIBS/x86/librgb_node.so -fPIC
cp -v $RUSTLIB/target/i686-linux-android/debug/librgb.so $JNILIBS/x86/
cp -v $NDK_HOME/sources/cxx-stl/llvm-libc++/libs/x86/libc++_shared.so $JNILIBS/x86/
