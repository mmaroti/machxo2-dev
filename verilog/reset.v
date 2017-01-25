module resetn_gen #(parameter WIDTH = 3) (
	input wire clock,
	input wire resetn_pio,
	output wire resetn);

reg [WIDTH-1:0] counter = 0;
assign resetn = (counter == {WIDTH{1'b1}});

always @(posedge clock)
begin
	if (!resetn_pio)
		counter <= 0;
	else if (!resetn)
		counter <= counter + 1'b1;
end

endmodule
