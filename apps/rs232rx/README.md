# Sending data from the PC to the FPGA using RS232

This application implements the receiver side of the modem and
and puts together a loopback channel. It reads data from the PC,
negates each byte read and writes it back to the PC. A sample
driver application is provided that achieves around 1160000 bytes/sec
throughput using the 12 megabaud setting of the FT2232 USB chip.
Since we use 1 start and 1 stop bits, we expect around 1.2 mbyte/sec
throughput, which is quite close to what we have measured.
