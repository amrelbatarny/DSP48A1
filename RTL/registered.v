module registered #(
	parameter REG = 0,
	parameter INWIDTH = 18,
	parameter RSTTYPE = "SYNC"
	)(
	input ce, rst, clk,
	input [INWIDTH-1:0] in,
	output [INWIDTH-1:0] out
	);

	reg [INWIDTH-1:0] registered;

	assign out = (REG)? registered : in;

	generate
		if(RSTTYPE == "ASYNC") begin
			always @(posedge clk or posedge rst) begin
				if(rst)
					registered <= 0;
				else if(ce)
					registered <= in;
			end
		end

		else if(RSTTYPE == "SYNC") begin
			always @(posedge clk) begin
				if(ce) begin
					if(rst)
						registered <= 0;
					else
						registered <= in;
				end
			end
		end
	endgenerate

endmodule