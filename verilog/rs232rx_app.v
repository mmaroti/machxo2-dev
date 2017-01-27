
module top(
	output reg [7:0] leds,
	input wire rs232_txd,
	output wire rs232_rxd,
//	input wire rs232_rtsn,
	output wire rs232_ctsn,
	input wire resetn_pio);

assign rs232_rxd = 1'b1;
assign rs232_ctsn = 1'b0;

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

wire resetn;
resetn_gen resetn_get(.clock(clock), .resetn(resetn), .resetn_pio(resetn_pio));

wire [7:0] data;
wire valid;

rs232_receive_bare #(.CLOCK_FREQ(133000000), .BAUD_RATE(12000000))
	rs232_rx(.clock(clock), .resetn(resetn), .rs232_txd(rs232_txd), .data(data), .valid(valid));

always @(posedge clock or negedge resetn)
begin
	if (!resetn)
		leds <= 8'b01010101;
	else
	begin
		if (valid)
			leds <= ~data;
	end
end

endmodule
