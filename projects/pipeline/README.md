# AXIS pipelines

We need to use some handshaking mechanism to connect internal components that produce and
consume data at different rate. This is unavoidable at the edges, for example at the RS232
or FT415 interface provided by the FT2232H chip on the breakout board. At the same time,
we want an handshaking mechanism where all outputs are registered so we can run the system
at maximal clock speed. One quite natural option is the so called valid/ready handshake where
data is transferred from a producer to the consumer when both valid and ready are asserted.

I have developed two components, the first is the [axis pipe](/verilog/axis.v) which I
think is the minimal implementation that can be inserted between a consumer and producer
without they noticing anything and also provides maximal throughput (one data per clock 
cycle). The implementation requires a registered data output (as we required) and an internal
data buffer in case the output data is not taken (output ready is low) and input data is
taken (input ready was high).

I have implemented a proper [axis fifo](/verilog/axis.v) which provides an internal
buffer (the pipe is just a special case with a single data buffer) of arbitrary size 
implemented in the distributed memory. It also provides the number of contained elements 
within the fifo which can be used for special flow control (for example for RS232 almost 
full condition).
