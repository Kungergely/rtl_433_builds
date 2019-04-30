#!/bin/bash

CPU_COUNT=$(nproc)
BUILD_HOME=${TRAVIS_BUILD_DIR}

mkdir -p ${BUILD_HOME}/src
mkdir -p ${BUILD_HOME}/build
mkdir -p ${BUILD_HOME}/bin

export PATH=$PATH:${BUILD_HOME}/build:${BUILD_HOME}/build/lib:${BUILD_HOME}/build/include:${BUILD_HOME}/bin

/bin/echo
/bin/echo -e "\e[93mCompiling libusb (for rtl-sdr)...\e[39m"
/bin/echo
cd ${BUILD_HOME}/src
git clone https://github.com/libusb/libusb.git
cd  ${BUILD_HOME}/src/libusb
./autogen.sh --prefix="${BUILD_HOME}/build" --bindir="${BUILD_HOME}/bin" --enable-shared --enable-static
make -j ${CPU_COUNT}
make install


/bin/echo
/bin/echo -e "\e[93mCompiling rtl-sdr...\e[39m"
/bin/echo
cd ${BUILD_HOME}/src
git clone https://github.com/osmocom/rtl-sdr.git
cd ${BUILD_HOME}/src/rtl-sdr
PKG_CONFIG_PATH="${BUILD_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${BUILD_HOME}/build" -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
make -j ${CPU_COUNT}
make install

/bin/echo
/bin/echo -e "\e[93mCompiling SoapySDR...\e[39m"
/bin/echo
cd ${BUILD_HOME}/src
git clone https://github.com/pothosware/SoapySDR.git
cd ${BUILD_HOME}/src/SoapySDR
# Yeah, it completely ignores any pleas for a static lib
sed -i "s/(SoapySDR SHARED/(SoapySDR STATIC/" lib/CMakeLists.txt
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${BUILD_HOME}/build" 
make -j ${CPU_COUNT}
make install

# We want a static build! No .so files!
cd ${BUILD_HOME}/build/lib
rm -rf *.so*
/bin/echo
/bin/echo -e "\e[93mCompiling rtl_433...\e[39m"
/bin/echo
RTLSDR="${RTLSDR:-ON}"
SOAPYSDR="${SOAPYSDR:-AUTO}"
set -- -DENABLE_RTLSDR=$RTLSDR -DENABLE_SOAPYSDR=$SOAPYSDR
cd ${BUILD_HOME}/src
git clone https://github.com/merbanan/rtl_433.git
cd ${BUILD_HOME}/src/rtl_433
mkdir build
cd build
cmake -G "Unix Makefiles" -DLIBUSB_INCLUDE_DIR="${BUILD_HOME}/build/include/libusb-1.0" ..
sed -i "s/-lstdc++//g" src/CMakeFiles/rtl_433.dir/link.txt
sed -i "s/$/ -lstdc++ -l:libudev.so/" src/CMakeFiles/rtl_433.dir/link.txt
make -j ${CPU_COUNT}

