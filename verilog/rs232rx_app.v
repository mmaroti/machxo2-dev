
module top(
	output reg [7:0] leds,
	input wire rs232_txd_pin,
	output wire rs232_rxd_pin,
	input wire rs232_rtsn_pin,
	output wire rs232_ctsn_pin,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

wire resetn;
resetn_gen resetn_get(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

wire [7:0] data1;
wire valid1, ready1;wire overflow, almostfull;
rs232_recv2 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) rs232_recv(
	.clock(clock), 
	.resetn(resetn), 
	.txd_pin(rs232_txd_pin), 
	.ctsn_pin(rs232_ctsn_pin),
	.odata(data1),
	.ovalid(valid1),
	.oready(ready1),
	.overflow(overflow),
	.almostfull(almostfull));

wire [7:0] data2;
wire valid2, ready2;
wire [2:0] size;
fifo #(.SIZE(7)) fifo(
	.clock(clock),
	.resetn(resetn),
	.size(size),
	.idata(data1),
	.ivalid(valid1),
	.iready(ready1),
	.odata(data2),
	.ovalid(valid2),
	.oready(ready2));
	
assign almostfull = size >= 2;

rs232_send3 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) rs232_send(
	.clock(clock),
	.resetn(resetn),
	.rxd_pin(rs232_rxd_pin),
	.rtsn_pin(rs232_rtsn_pin),
	.data(data2),
	.valid(valid2),
	.ready(ready2));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b11111111;
	else
	begin
		leds[7] <= ~overflow;
		leds[6:4] <= ~size;
		leds[3] <= ~valid1;
		leds[2] <= ~ready1;
		leds[1] <= ~valid2;
		leds[0] <= ~ready2;
	end
end

endmodule
