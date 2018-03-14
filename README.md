# machxo2-dev

This repository contains FPGA and driver examples for the [MachXO2 Breakout Board](http://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/MachXO2BreakoutBoard), 
but the code should work on any FPGA. The reusable verilog modules are under the 
[verilog](verilog) directory. The following example projects are provided:
* [Blink](projects/blink) application
* [Reset](projects/reset) application with debouncing [reset.v](verilog/reset.v) module

# Linux setup notes

## Install the Lattice Diamond software
I have followed steps 1 and 2 from these 
[instructions](https://ycnrg.org/lattice-diamond-on-ubuntu-16-04/)
with the following differences:
* I used `sudo apt-get install python-libusb1` instead of `sudo pip install libusb1`
* I have moved the `diamond` directory to `/opt` instead of `/usr/local` with the command
`sudo cp -Rva --no-preserve=ownership ./usr/local/diamond /opt/`
* I have added the line `PATH="$PATH="$PATH:/opt/diamond/3.10_x64/bin/lin64/"` to the end of my `.profile`
* When you first run diamond it will ask for your license file. You can get a free license
from lattice, and I have copied that to the `/opt/diamond/3.10_x64/license/` directory.

## Installing the FTDI N2xx drivers (needed to read/write EEPROM and to use advanced modes)
* Download the latest drivers from http://www.ftdichip.com/Drivers/D2XX.htm
* Follow the instructions in the ReadMe.txt by copying the libftd2xx.so file to /usr/lib/local
* Use the provided `sudo ./read` program to verify that you can read the EEPROM. After plugging in
your device you need to unload the default drivers by `sudo rmmod ftdi_sio` and `sudo rmmod usbserial`.

## Useful links
* http://playground.arduino.cc/Linux/Udev
* https://github.com/wendlers/lattice-logic-sniffer
* http://www.eevblog.com/forum/microcontrollers/lattice-diamond-is-making-me-sad/
* https://www.youtube.com/watch?v=UOECwHhCWRg
* https://www.youtube.com/watch?v=SmdEP_ZsBgM
* https://www.intra2net.com/en/developer/libftdi/download.php
* https://github.com/RandomReaper/ft2tcp/blob/master/eeprom-config/
* http://m-labs.hk/milkymist-wiki/wiki/index.php%3Ftitle=Working_ftdi_eeprom.html
* https://github.com/henryeherman/Platypus/blob/master/doc/source/fpgadevelopment.rst

