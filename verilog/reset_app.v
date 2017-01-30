module top(
	output reg [7:0] leds,
	input wire resetn_pin);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

wire resetn;
resetn_gen resetn_gen(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

reg [31:0] counter;
always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		counter <= 32'hF0000000;
	else
		counter <= counter + 1'b1;
end

always @(posedge clock)
begin
	leds <= ~counter[31:24];
end

endmodule
