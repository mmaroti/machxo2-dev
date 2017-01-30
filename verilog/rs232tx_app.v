module top(
	output reg [7:0] leds,
//	input wire rs232_txd_pin,
	output wire rs232_rxd_pin,
	input wire rs232_rtsn_pin,
//	output wire rs232_ctsn_pin,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

wire resetn;
resetn_gen resetn_gen(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

reg [7:0] data;
reg push;
wire full;

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
	begin
		data <= 8'b0;
		push <= 1'b0;
	end
	else if (full)
		push <= 1'b0;
	else
	begin
		data <= data + 1'b1;
		push <= 1'b1;
	end
end


always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b01010101;
	else
		leds <= ~data;
end
/*
push_to_rs232 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) sender(
	.clock(clock), 
	.resetn(resetn),
	.data(data),
	.push(push),
	.full(full),
	.rxd_pin(rs232_rxd_pin), 
	.rtsn_pin(rs232_rtsn_pin));
*/

rs232_send3 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) sender(
	.clock(clock), 
	.resetn(resetn),
	.data(data),
	.valid(push),
	.ready(full),
	.rs232_rxd(rs232_rxd_pin), 
	.rs232_rtsn(rs232_rtsn_pin));

endmodule
