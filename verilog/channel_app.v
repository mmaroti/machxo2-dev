module top(
	input wire clock,
	input wire resetn_pin,
	input wire enable1,
	input wire enable2,
	output reg [7:0] leds);

// wire clock;
// OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

resetn_gen resetn_get(.clock(clock), .resetn(resetn), .resetn_pin(resetn_pin));

wire [7:0] data1;
wire valid1, ready1;

counter counter(
	.clock(clock), 
	.resetn(resetn), 
	.odata(data1), 
	.ovalid(valid1), 
	.oready(ready1 && enable1));

wire [7:0] data2;
wire valid2;

buffer #(.SIZE(2)) buffer(
	.clock(clock), 
	.resetn(resetn),
	.size(),
	.idata(data1),
	.ivalid(valid1 && enable1),
	.iready(ready1),
	.odata(data2),
	.ovalid(valid2),
	.oready(enable2));

/*
pipe pipe(
	.clock(clock), 
	.resetn(resetn),
	.idata(data1),
	.ivalid(valid1 && enable1),
	.iready(ready1),
	.odata(data2),
	.ovalid(valid2),
	.oready(enable2));
*/

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= ~8'hFF;
	else if (valid2 && enable2)
		leds <= ~data2;
end

endmodule
