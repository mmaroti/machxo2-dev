// Copyright (C) 2017, Miklos Maroti

module resetn_gen #(parameter WIDTH = 2) (
	input wire clock,
	input wire resetn_pin,
	output reg resetn);

reg resetn_pin2;
initial resetn_pin2 <= 1'b1;

// to avoid metastability
always @(posedge clock)
begin
	resetn_pin2 <= resetn_pin;
end

reg [WIDTH-1:0] counter = 0;

always @(posedge clock)
begin
	if (resetn_pin2 == resetn)
		counter <= 1'b0;
	else
		{resetn, counter} <= {resetn, counter} + 1'b1;
end

endmodule
