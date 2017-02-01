module top(
	output wire [7:0] leds,
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

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		data <= 8'b0;
	else
		data <= data + 1'b1;
end

assign leds = ~data;

rs232_send4 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) sender(
	.clock(clock), 
	.resetn(resetn),
	.data(data),
	.rden(),
	.empty(1'b0),
	.rxd_pin(rs232_rxd_pin), 
	.rtsn_pin(rs232_rtsn_pin));

/*
rs232_send3 #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) sender(
	.clock(clock), 
	.resetn(resetn),
	.data(data),
	.valid(1'b1),
	.ready(),
	.rs232_rxd(rs232_rxd_pin), 
	.rs232_rtsn(rs232_rtsn_pin));
*/
endmodule
