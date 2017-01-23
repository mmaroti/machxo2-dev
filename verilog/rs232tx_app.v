module top(
	output reg [7:0] leds,
	input wire ft232_txd,
	output wire ft232_rxd,
	input wire ft232_rts_n,
	output reg ft232_cts_n);

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

reg [7:0] counter;

initial counter <= 8'b0;

always @(posedge clock)
begin
	ft232_cts_n = 1'b0;

	leds[0] <= !ft232_txd;
	leds[1] <= !ft232_rxd;
	leds[2] <= !ft232_rts_n;
	leds[3] <= !ft232_cts_n;
	leds[4] <= !counter[4];
	leds[5] <= !counter[5];
	leds[6] <= !counter[6];
	leds[7] <= !counter[7];
end

rs232_send #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000))
	send(clock, 1'b1, ft232_rxd, ft232_rts_n, counter, 1'b1, ready);

always @(posedge clock)
begin
	if (ready)
		counter <= counter + 1'b1;
end

endmodule
