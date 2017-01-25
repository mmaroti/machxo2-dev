module top(
	output reg [7:0] leds,
	input wire rs232_txd,
	output wire rs232_rxd,
//	input wire rs232_rtsn,
	output wire rs232_ctsn);

assign rs232_rxd = 1'b1;
assign rs232_ctsn = 1'b0;

wire clock;
OSCH #(.NOM_FREQ("133.00")) rc_osc(.STDBY(1'b0), .OSC(clock), .SEDSTDBY());

reg [28:0] counter;
always @(posedge clock) 
begin
	counter <= counter + 1'b1;
end

wire resetn;
assign resetn = counter > 20000000;

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
		leds[0] <= !data[0];
		leds[1] <= !data[1];
		leds[2] <= !data[2];
		leds[3] <= !data[3];
		leds[4] <= !data[4];
		leds[5] <= !data[5];
		leds[6] <= !data[6];
		leds[7] <= !data[7];
/*
		leds[4] <= !rs232_txd;
		leds[5] <= !rs232_rxd;
		leds[6] <= !rs232_rtsn;
		leds[7] <= !rs232_ctsn;
*/
	end
end

endmodule
