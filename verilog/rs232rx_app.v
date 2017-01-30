
module top(
	output reg [7:0] leds,
	input wire rs232_txd_pin,
	output wire rs232_rxd_pin,
//	input wire rs232_rtsn_pin,
	output wire rs232_ctsn_pin,
	input wire resetn_pin);

assign rs232_rxd_pin = 1'b1;

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

wire resetn;
resetn_gen resetn_get(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

wire [7:0] data;
wire push;
rs232_to_push #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000)) rs232_rx(
	.clock(clock), 
	.resetn(resetn), 
	.txd_pin(rs232_txd_pin), 
	.ctsn_pin(rs232_ctsn_pin),
	.data(data),
	.push(push),
	.full(1'b0));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b01010101;
	else
	begin
		if (push)
			leds <= ~data;
	end
end

endmodule
