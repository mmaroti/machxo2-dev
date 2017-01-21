module top(
	output reg [7:0] leds,
	input wire ft232_txd,
	output reg ft232_rxd,
	input wire ft232_rts_n,
	output reg ft232_cts_n);

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

reg [29:0] counter;

initial counter <= 30'b0;

always @(posedge clock)
begin
	ft232_rxd = 1'b1;
	ft232_cts_n = 1'b1;
	counter <= counter + 30'b1;
	// leds <= counter[29:22];
	leds[0] <= ft232_txd;
	leds[1] <= ft232_rxd;
	leds[2] <= ft232_rts_n;
	leds[3] <= ft232_cts_n;
	leds[7:4] <= counter[29:26];
end

// rs232_send #(.CLOCK_FREQ(133000000), .BAUD_RATE(115200))
//	send(clock, 1'b0, rs232_rxd, rs232_rts_n, counter[29:22], 1'b1, ready);

endmodule
