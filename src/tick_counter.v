/**
 * Copyright (C) 2017, Miklos Maroti
 * This is free software released under the 3-clause BSD licence.
 */

module tick_counter #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire tick,
	output reg [WIDTH-1:0] count);

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		count <= 1'b0;
	else if (tick)
		count <= count + 1'b1;
end
endmodule
