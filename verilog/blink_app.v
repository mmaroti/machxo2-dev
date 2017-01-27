module top(output reg [7:0] leds);

wire clk;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clk), .SEDSTDBY());

reg [31:0] counter;

initial counter <= 32'b0;

always @(posedge clk)
begin
	counter <= counter + 1'b1;
	leds <= ~counter[31:24];
end

endmodule
