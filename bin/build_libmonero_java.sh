#!/bin/bash

#EMCC_DEBUG=1

CURRENT_ARCH=`uname -m`
CUR_OS=`uname -s`
HOST_NCORES=$(nproc 2>/dev/null || shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)

    CPU=""
    if [ -z "${ARCH}" ]; then
        CPU=$CURRENT_ARCH 
    else
        CPU="${ARCH}"
    fi

mkdir -p ./external-libs/monero-cpp/

# VENDOR=""
# if [ -n "$TARGET" ]; then 
#     VENDOR=$TARGET
# elif [ $CUR_OS == "Linux" ]; then
#     VENDOR="linux"
# else
#     VENDOR="apple"
# fi
# 
# OS=$CUR_OS
# if [ VENDOR == ]; then 
#     VENDOR=$TARGET
# fi

#     VERSION="${CURRENT_ARCH}-apple-${CUR_OS}"
#         VERSION="${CPU}-${VENDOR}-${OS}" 

if [ $CUR_OS == "Linux" ]; then
    # build libmonero-cpp shared library
    cd ./external/monero-cpp/
    ARCH=$ARCH SKIP_MP=$SKIP_MP TARGET=$TARGET ./bin/build_libmonero_cpp.sh &&
    cd ../.. &&
    cp external/monero-cpp/build/libmonero-cpp* ./external-libs/monero-cpp/ 

    # build libmonero-java shared library to ./build
    mkdir -p ./build &&
    cd build && 
    cmake .. && 
    cmake --build . -j$HOST_NCORES && 
    make .






else
# Not running on Linux
# Only build for the current platform
# build libmonero-cpp shared library
cd ./external/monero-cpp/ && 
./bin/build_libmonero_cpp.sh &&
cd ../../ &&
cp ./external/monero-cpp/build/libmonero-cpp* ./external-libs/monero-cpp/ &&

# build libmonero-java shared library to ./build
mkdir -p ./build &&
cd build && 
cmake .. && 
cmake --build . -j$HOST_NCORES && 
make .
fi
