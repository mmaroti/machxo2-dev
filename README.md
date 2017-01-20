# machxo2-dev

# Linux setup notes

## Installing the FTDI N2xx drivers (needed to read/write EEPROM and to use advanced modes)
* Download the latest drivers from http://www.ftdichip.com/Drivers/D2XX.htm
* Follow the instructions in the ReadMe.txt by copying the libftd2xx.so file to /usr/lib/local
* Use the provided `sudo ./read` program to verify that you can read the EEPROM. After plugging in
your device you need to unload the default drivers by `sudo rmmod ftdi_sio` and `sudo rmmod usbserial`.

## Links (need to finish setup)
* http://playground.arduino.cc/Linux/Udev
* https://github.com/wendlers/lattice-logic-sniffer
* http://www.eevblog.com/forum/microcontrollers/lattice-diamond-is-making-me-sad/
* https://www.youtube.com/watch?v=UOECwHhCWRg
* https://www.youtube.com/watch?v=SmdEP_ZsBgM
* https://www.intra2net.com/en/developer/libftdi/download.php
* https://github.com/RandomReaper/ft2tcp/blob/master/eeprom-config/
* http://m-labs.hk/milkymist-wiki/wiki/index.php%3Ftitle=Working_ftdi_eeprom.html
* http://www.ftdichip.com/Drivers/D2XX.htm
* http://m-labs.hk/milkymist-wiki/wiki/index.php%3Ftitle=Working_ftdi_eeprom.html

## How to setup LXC/Centos for Lattice Diamond
* need user access to device (chown/chgrp)
* need to setup X11
* need to allow libusb and libftdi there

