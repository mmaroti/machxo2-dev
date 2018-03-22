# Sending data from the FPGA to the PC using RS232

The MachXO2 breakout board has a built in FTDI FT2232H chip. That chip has two channels: channel A is used for programming and channel B can be used for serial communication. I have implemented an 
RS232 serial transmitter [rs232tx.v](../../verilog/rs232tx.v) module that accepts an AXI stream of
bytes and sends it to the FT2232H chip. This was rather difficult (at least for me) even though
there are plenty of examples on the internet. The main problem was minimal use of FPGA resources
and to provide hardware flow control using the CTSn signal.

The [rs232tx_app.v](rs232tx_app.v) application connects an AXIS counter to the serial transmitter 
and sends the data with 12000000 baud, the maximum rate supported by the FT2232H chip. You need
a [driver](driver.c) program on the PC to read the sent bytes. This is written in C and a Makefile
is provided. You need to install the `libftdi1` library (`sudo apt-get install libftdi1-dev`) to be 
able to compile it. From the driver we toggle the RTSn signal (which is connected to the CTSn pin)
to enable the production of bytes from the counter into the FT2232H chip, then we simply read out
those bytes. When you run this program multiple times you should get consecutive numbers and the
next run should pick up the count where the last one left off. The LEDs should display the next
byte that will be read.
