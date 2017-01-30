module resetn_gen #(parameter WIDTH = 4) (
	input wire clock,
	input wire resetn_pin,
	output wire resetn);

reg [WIDTH-1:0] counter = 0;
assign resetn = (counter == {WIDTH{1'b1}});

reg resetn_pin2;
initial resetn_pin2 <= 1'b1;

always @(posedge clock)
begin
	resetn_pin2 <= resetn_pin;
	
	if (!resetn_pin2)
		counter <= 0;
	else if (!resetn)
		counter <= counter + 1'b1;
end

endmodule
