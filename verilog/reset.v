module resetn_gen #(parameter WIDTH = 4) (
	input wire clock,
	input wire resetn_pin,
	output wire resetn);

reg resetn_pin2;
initial resetn_pin2 <= 1'b1;

always @(posedge clock)
begin
	resetn_pin2 <= resetn_pin;
end

reg [WIDTH-1:0] counter = 0;
assign resetn = counter[WIDTH-1];

always @(posedge clock)
begin
	if (!resetn_pin2)
		counter <= 1'b0;
	else if (!resetn)
		counter <= counter + 1'b1;
end

endmodule
