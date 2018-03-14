// Copyright (C) 2017, Miklos Maroti

module top(
	output reg [7:0] leds,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

// make the width 27 for testing purposes (requires around 1 sec long press)
wire resetn;
resetn_gen #(.WIDTH(27)) resetn_gen(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

reg [31:0] counter;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		counter <= 1'b0;
	else
		counter <= counter + 1'b1;
end

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b10101010;
	else
		leds <= ~counter[31:24];
end

endmodule
