# portenta-tools
Build and debug tools for Arduino Portenta H7

## Build debug mbed core for Portenta H7

First, make sure you have the necessary prerequisites for the `mbed` toolchain. On Ubuntu, you can use:

```sh
sudo apt install python3 python3-pip git mercurial gcc-arm-none-eabi
python3 -m pip install --user mbed-cli
```

Clone this repository, which includes changes to enable debug builds and various `mbed-os` source patches:

```sh
git clone --recurse-submodules https://github.com/ardnew/portenta-tools
```

Install all of the necessary dependencies:

```sh
python3 -m pip install --user -r portenta-tools/mbed/os/requirements.txt
arduino-cli lib install lvgl # or install "lvgl" through Arduino IDE package manager
```

And finally, run the build script:

```sh
cd portenta-tools
./build.sh
```

This should generate a new Arduino Portenta H7 core with debug symbols at `/tmp/mbed-os-program/BUILD/mbed-core-PORTENTA_H7_M7.a`.
