# rtl_433_builds
Git snapshot builds of [rtl_433](https://github.com/merbanan/rtl_433) for x86_64 Linux, Windows and both 32 and 64-bit Raspberry Pi (running Linux). Everything (including [libusb](https://github.com/libusb/libusb), [rtl-sdr](https://github.com/osmocom/rtl-sdr) and [SoapySDR](https://github.com/pothosware/SoapySDR/)) has been linked statically to avoid the hassle of having to copy shared libraries on embedded devices. Just a single executable with optional config files. WARNING: SoapySDR is refusing to compile on MinGW at the moment thus it's not available in the Windows build yet.

Initially I tried to use [dockcross](https://github.com/dockcross/dockcross) for ARM cross-compilation, but it turned out to be too cumbersome (and not powerful enough) for my purpose. So instead I've rolled a dockerfile on my own with using this [Dockerfile from Parity](https://hub.docker.com/r/parity/rust-arm64/dockerfile/) for hints. The .travis.yml config file of the [ludo](https://github.com/libretro/ludo) repository was also tremendously helpful in making cross-compilation work under Travis CI as well.

Most of the embedded devices are still running on 32-bit SoCs, so I've included builds for both 32 and 64-bit ARM platforms. The 64-bit ARM build is only supported by a few OSes running on a handful of SBCs:
- Raspberry Pi models supported by the aarch64/arm64 build: RPi 2 Model B v1.2, RPi 3 Model A+, RPi 3 Model B/B+, Compute Module 3/3+, Compute Module 3 lite
- Banana Pi models supported by the aarch64/arm64 build: Banana Pi M64, Banana Pi BPI-W2, Banana PI BPI-R64, 
- Orange Pi models supported by the aarch64/arm64 build: Orange Pi PC 2, Orange Pi Win, Orange Pi 3, Orange Pi 4G-IOT, Orange Pi RK3399, Orange Pi Zero Plus, Orange Pi Prime, Orange Pi Win Plus, Orange Pi Zero Plus2, Orange Pi Lite 2, Orange Pi One Plus

NOTE: Some OSes, most notably OpenELEC, LibreELEC and OSMC are running in 32-bit mode even on 64-bit capable ARM hardware. In such cases you have to use the armv7/armhf build instead of the 64-bit one.

Older devices not mentioned here will probably run the armhf build just fine. In case you need armel binaries just let me know.

All the builds are produced using Travis CI. I've also included the Dockerfiles that I've used for creating/fine-tuning the Travis script (all of which are based on Ubuntu 16.04 Xenial). To build them, just check out the repo and run the following command inside its folder:
```
docker build --rm -f Dockerfile.desired_platform .
```
This will produce ready-made builds of rtl_433 inside a Docker image. To extract it, you can either run `docker cp` after starting up a container from the finished build image or run a container with `docker run -it --irm -v ~/rtl_433_builds:/root/rtl_433/src/rtl_433/build/ /bin/bash` and copy it that way.
