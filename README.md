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

## Portenta H7 JTAG/SWD Interface

Unfortunately, the SWD pins on Portenta H7 are only available using the 80-pin high-density connectors. However, Arduino is happy to give you access to them with their [Arduino Portenta Breakout](https://store.arduino.cc/usa/portenta-breakout) board (for a cool **$50 USD**).

But, just to keep you on your toes, they throw a couple curveballs: 

1. First, it isn't the usual 10-pin Cortex-M header (2x5, 2.54mm pitch), but instead a 20-pin MIPI 20T JTAG (2x10, 2.54mm pitch) header. 
    - This means the 10-pin ribbon cable you use with, e.g., JLink EDU Mini or Black Magic Probe, will not work - not even with a little spit and muscle (trust me). Luckily, the JLink EDU Mini I purchased from Adafruit many moons ago actually came with this 20-pin cable. Hope you haven't lost or cannibalized yours!
2. Second, the breakout board's official pinout documentation for the JTAG header is (very) wrong. The documentation lists JTAG pin 1 (`+3V3`) at the top-left of the pinout diagram, but it is actually located at the bottom-right, where pin 20 is located. In fact, the entire header should be rotated 180 degrees. I've made all of these changes in the **corrected** diagram below:

![Corrected JTAG Pinout](extra/jtag-pinout-corrected.png)
