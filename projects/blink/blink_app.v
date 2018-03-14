/**
 * Copyright (C) 2017, Miklos Maroti
 * This file is released under the 3-clause BSD licence.
 */

module top(output reg [7:0] leds);

wire clock;
OSCH #(.NOM_FREQ("133.00")) osch(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

reg [31:0] counter;

initial counter <= 32'b0;

always @(posedge clock)
begin
	counter <= counter + 1'b1;
	leds <= ~counter[31:24];
end

endmodule
