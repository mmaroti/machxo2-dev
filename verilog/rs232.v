/*
This module provides RS232 communication. The clock frequency does not have to be an
integer multiple of the boud rate.
*/

module rs232_send #(parameter CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	output reg rs232_rxd,
	input wire rs232_rtsn,
	input wire [7:0] data,
	input wire valid,
	output reg ready);

	localparam integer
		START = 0,
		BIT_0 = (CLOCK_FREQ + BAUD_RATE / 2) / BAUD_RATE,
		BIT_1 = (CLOCK_FREQ * 2 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_2 = (CLOCK_FREQ * 3 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_3 = (CLOCK_FREQ * 4 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_4 = (CLOCK_FREQ * 5 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_5 = (CLOCK_FREQ * 6 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_6 = (CLOCK_FREQ * 7 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_7 = (CLOCK_FREQ * 8 + BAUD_RATE / 2) / BAUD_RATE,
		STOP = (CLOCK_FREQ * 9 + BAUD_RATE / 2) / BAUD_RATE,
		FINISH = (CLOCK_FREQ * 10 + BAUD_RATE / 2) / BAUD_RATE;

	localparam integer
		TIMER_WIDTH = $clog2(FINISH);

	reg [7:0] buffer;
	reg [TIMER_WIDTH-1:0] timer;
	reg running;

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn || !running)
		begin
			timer <= 0;
			rs232_rxd <= 1'b1;
		end
		else
		begin
			if (timer == START)
				rs232_rxd <= 1'b0;
			else if (timer == BIT_0)
				rs232_rxd <= buffer[0];
			else if (timer == BIT_1)
				rs232_rxd <= buffer[1];
			else if (timer == BIT_2)
				rs232_rxd <= buffer[2];
			else if (timer == BIT_3)
				rs232_rxd <= buffer[3];
			else if (timer == BIT_4)
				rs232_rxd <= buffer[4];
			else if (timer == BIT_5)
				rs232_rxd <= buffer[5];
			else if (timer == BIT_6)
				rs232_rxd <= buffer[6];
			else if (timer == BIT_7)
				rs232_rxd <= buffer[7];
			else if (timer == STOP)
				rs232_rxd <= 1'b1;

			timer <= timer + 1'b1;
		end
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			buffer <= 8'bx;
			running <= 1'b0;
			ready <= 1'b0;
		end
		else if (running)
		begin
			if (timer == FINISH-1)
			begin
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rs232_rtsn;
			end
		end
		else
		begin
			if (ready && valid)
			begin
				buffer <= data;
				running <= 1'b1;
				ready <= 1'b0;
			end
			else
			begin
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rs232_rtsn;
			end
		end
	end

endmodule

module rs232_send3 #(parameter integer CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	output reg rs232_rxd,
	input wire rs232_rtsn,
	input wire [7:0] data,
	input wire valid,
	output reg ready);

	// metastable buffering
	reg rtsn_pin2, rtsn;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			rtsn_pin2 <= 1'b1;
			rtsn <= 1'b1;
		end
		else
		begin
			rtsn_pin2 <= rs232_rtsn;
			rtsn <= rtsn_pin2;
		end
	end

	localparam integer
		START = 0,
		BIT_0 = (CLOCK_FREQ + BAUD_RATE / 2) / BAUD_RATE,
		BIT_1 = (CLOCK_FREQ * 2 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_2 = (CLOCK_FREQ * 3 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_3 = (CLOCK_FREQ * 4 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_4 = (CLOCK_FREQ * 5 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_5 = (CLOCK_FREQ * 6 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_6 = (CLOCK_FREQ * 7 + BAUD_RATE / 2) / BAUD_RATE,
		BIT_7 = (CLOCK_FREQ * 8 + BAUD_RATE / 2) / BAUD_RATE,
		STOP = (CLOCK_FREQ * 9 + BAUD_RATE / 2) / BAUD_RATE,
		FINISH = (CLOCK_FREQ * 10 + BAUD_RATE / 2) / BAUD_RATE;

	localparam integer
		TIMER_WIDTH = $clog2(FINISH);

	reg [7:0] buffer;
	reg [TIMER_WIDTH-1:0] timer;
	reg running;

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn || !running)
			timer <= 0;
		else
			timer <= timer + 1'b1;
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			rs232_rxd <= 1'b1;
			buffer = 8'bx;
			running <= 1'b0;
			ready <= 1'b0;
		end
		else if (running)
		begin
			if ((timer == BIT_0)
				|| (timer == BIT_1)
				|| (timer == BIT_2)
				|| (timer == BIT_3)
				|| (timer == BIT_4)
				|| (timer == BIT_5)
				|| (timer == BIT_6)
				|| (timer == BIT_7)
				|| (timer == STOP))
			begin
				rs232_rxd <= buffer[0];
				buffer[0] <= buffer[1];
				buffer[1] <= buffer[2];
				buffer[2] <= buffer[3];
				buffer[3] <= buffer[4];
				buffer[4] <= buffer[5];
				buffer[5] <= buffer[6];
				buffer[6] <= buffer[7];
				buffer[7] <= 1'b1;
			end

			if (timer == FINISH-1)
			begin
				running <= 1'b0;
				ready <= !rtsn;
			end
		end
		else
		begin
			if (ready && valid)
			begin
				rs232_rxd <= 1'b0;
				buffer <= data;
				running <= 1'b1;
				ready <= 1'b0;
			end
			else
			begin
				rs232_rxd <= 1'b1;
				buffer <= 8'bx;
				running <= 1'b0;
				ready <= !rtsn;
			end
		end
	end

endmodule

module rs232_send4 #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire [7:0] data,
	output reg rden,
	input wire empty,
	output reg rxd_pin,
	input wire rtsn_pin);

	// metastable buffering
	reg rtsn_pin2, rtsn;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			rtsn_pin2 <= 1'b1;
			rtsn <= 1'b1;
		end
		else
		begin
			rtsn_pin2 <= rtsn_pin;
			rtsn <= rtsn_pin2;
		end
	end

	localparam real UNIT = 1.0 * CLOCK_FREQ / BAUD_RATE;

	// rounded to the nearest integer
	localparam [63:0]
		START = 1,
		BIT_0 = UNIT * 1.0 + 1,
		BIT_1 = UNIT * 2.0 + 1,
		BIT_2 = UNIT * 3.0 + 1,
		BIT_3 = UNIT * 4.0 + 1,
		BIT_4 = UNIT * 5.0 + 1,
		BIT_5 = UNIT * 6.0 + 1,
		BIT_6 = UNIT * 7.0 + 1,
		BIT_7 = UNIT * 8.0 + 1,
		STOP = UNIT * 9.0 + 1,
		FINISH = UNIT * 10.0 - 1;

	localparam integer TIMER_WIDTH = $clog2(FINISH + 1);

	reg [TIMER_WIDTH-1:0] timer;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			timer <= 1'b0;
		else if ((timer == 0 && (empty || rtsn)) || timer == FINISH)
			timer <= 1'b0;
		else
			timer <= timer + 1'b1;
	end

	reg [7:0] buffer;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			rxd_pin <= 1'b1;
			buffer <= 8'hxx;
		end
		else if (timer == START)
		begin
			rxd_pin <= 1'b0;
			buffer <= data;
		end
		else if (timer == BIT_0 || timer == BIT_1 || timer == BIT_2 || timer == BIT_3
			|| timer == BIT_4 || timer == BIT_5 || timer == BIT_6 || timer == BIT_7
			|| timer == STOP)
		begin
			rxd_pin <= buffer[0];
			buffer[6:0] <= buffer[7:1];
			buffer[7] <= 1'b1;
		end
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			rden <= 1'b0;
		else
			rden <= timer == 0 && !empty && !rtsn;
	end

endmodule

module rs232_recv #(parameter real CLOCK_FREQ=133000000, BAUD_RATE=115200) (
	input wire clock,
	input wire resetn,
	input wire txd_pin,
	output wire ctsn_pin,
	output reg [7:0] data,
	output reg wren,
	input wire afull);

	// metastable buffering
	reg txd_pin2, txd;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			txd_pin2 <= 1'b1;
			txd <= 1'b1;
		end
		else
		begin
			txd_pin2 <= txd_pin;
			txd <= txd_pin2;
		end
	end

	assign ctsn_pin = afull;

	localparam real UNIT = 1.0 * CLOCK_FREQ / BAUD_RATE;

	// rounded to the nearest integer
	localparam [63:0]
		START = UNIT * 0.5 - 0.5,
		BIT_0 = UNIT * 1.5 - 0.5,
		BIT_1 = UNIT * 2.5 - 0.5,
		BIT_2 = UNIT * 3.5 - 0.5,
		BIT_3 = UNIT * 4.5 - 0.5,
		BIT_4 = UNIT * 5.5 - 0.5,
		BIT_5 = UNIT * 6.5 - 0.5,
		BIT_6 = UNIT * 7.5 - 0.5,
		BIT_7 = UNIT * 8.5 - 0.5,
		STOP =  UNIT * 9.5 - 0.5;

	localparam integer TIMER_WIDTH = $clog2(STOP + 1);

	reg [TIMER_WIDTH-1:0] timer;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			timer <= 1'b0;
		else if (((timer <= START) && txd) || timer == STOP)
			timer <= 1'b0;
		else
			timer <= timer + 1'b1;
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			wren <= 1'b0;
		else
			wren <= timer == STOP && txd;
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			data <= 8'bx;
		else if (timer == BIT_0 || timer == BIT_1 || timer == BIT_2 || timer == BIT_3
			|| timer == BIT_4 || timer == BIT_5 || timer == BIT_6 || timer == BIT_7)
		begin
			data[6:0] <= data[7:1];
			data[7] <= txd;
		end
	end

endmodule

module buffer #(parameter integer WIDTH = 8, SIZE = 4, AFULL = 2) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire iwren,
	output reg iafull,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	localparam integer SIZE_WIDTH = $clog2(SIZE + 1);
	integer i;

	wire itransfer = iwren;
	wire otransfer = ovalid && oready;
	reg [SIZE_WIDTH-1:0] size;
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			size <= 1'b0;
		else if (itransfer && !otransfer)
			size <= size + 1'b1;
		else if (!itransfer && otransfer)
			size <= size - 1'b1;
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			iafull <= 1'b1;
		else
			iafull <= (size >= AFULL);
	end

	reg [WIDTH-1:0] buffer[0:SIZE-1];
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			for (i = 0; i < SIZE; i = i + 1)
				buffer[i] <= {WIDTH{1'bx}};
		end
		else if (itransfer)
		begin
			buffer[0] <= idata;
			for (i = 1; i < SIZE; i = i + 1)
				buffer[i] <= buffer[i - 1]; 
		end
	end

	reg [WIDTH-1:0] buffer2[0:SIZE];
	always @(*)
	begin
		buffer2[0] = idata;
		for (i = 1; i <= SIZE; i = i + 1)
			buffer2[i] = buffer[i - 1];
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			odata <= {WIDTH{1'bx}};
		else if (otransfer)
			odata <= buffer2[size];
	end

endmodule
