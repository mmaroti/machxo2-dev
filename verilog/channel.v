/*
Moves data from idata to odata. Data is transferred on the ports
when both xvalid and xready are high on the rising edge of the clock.
*/

module pipe #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	reg [WIDTH-1:0] buffer; // bvalid = !iready (&& ovalid)

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			iready <= 1'b1;
			odata <= {WIDTH{1'bx}};
			ovalid <= 1'b0;
			buffer <= {WIDTH{1'bx}};
		end
		else
		begin
			ovalid <= (ovalid && !oready) || !iready || ivalid;
			odata <= (ovalid && !oready) ? odata : (!iready ? buffer : idata);

			iready <= !ovalid || oready || (iready && !ivalid);
			buffer <= (ovalid && !oready && iready && ivalid) ? idata : buffer;
		end
	end

endmodule

module pull2chan #(parameter WIDTH = 8) (
	input wire clock,
	input wire resetn,
	input wire [WIDTH-1:0] idata,
	input wire iempty,
	output reg irden,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	reg [WIDTH-1:0] buffer;
	reg bvalid;

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			irden <= 1'b0;
			odata <= {WIDTH{1'bx}};
			ovalid <= 1'b0;
			buffer <= {WIDTH{1'bx}};
			bvalid <= 1'b0;
		end
		else
		begin
			ovalid <= (ovalid && !oready) || bvalid || irden;
			odata <= (ovalid && !oready) ? odata : (bvalid ? buffer : idata);

			bvalid <= ovalid && !oready && (irden || bvalid);
			buffer <= (ovalid && !oready && irden) ? idata : buffer;

			irden <= !iempty && !(ovalid && !oready && (irden || bvalid));
		end
	end

endmodule

module buffer #(parameter integer WIDTH = 8, SIZE = 3, SIZE_WIDTH = $clog2(SIZE + 1)) (
	input wire clock,
	input wire resetn,
	output reg [SIZE_WIDTH-1:0] size,
	input wire [WIDTH-1:0] idata,
	input wire ivalid,
	output reg iready,
	output reg [WIDTH-1:0] odata,
	output reg ovalid,
	input wire oready);

	integer i;

	wire itransfer = ivalid && iready;
	wire otransfer = ovalid && oready;
	
	wire [SIZE_WIDTH-1:0] size2 = size - otransfer;
	wire [SIZE_WIDTH-1:0] size3 = size2 + itransfer;

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			size <= 1'b0;
			iready <= 1'b0;
			ovalid <= 1'b0;
		end
		else
		begin
			size <= size3;
			iready <= size3 != SIZE;
			ovalid <= size3 != 0;
		end
	end

	reg [WIDTH-1:0] buffer[1:SIZE-1];
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
		begin
			for (i = 1; i < SIZE; i = i + 1)
				buffer[i] <= {WIDTH{1'bx}};
		end
		else if (itransfer)
		begin
			buffer[1] <= idata;
			for (i = 2; i < SIZE; i = i + 1)
				buffer[i] <= buffer[i - 1];
		end
	end

	reg [WIDTH-1:0] buffer2[0:SIZE];
	always @(*)
	begin
		buffer2[0] = idata;
		for (i = 1; i < SIZE; i = i + 1)
			buffer2[i] = buffer[i];
		buffer2[SIZE] = odata;
	end

	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			odata <= {WIDTH{1'bx}};
		else if (otransfer)
			odata <= buffer2[size2];
	end

endmodule
