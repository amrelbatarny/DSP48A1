module DSP48A1 #(
	parameter A0REG = 0,
	parameter A1REG = 1,
	parameter B0REG = 0,
	parameter B1REG = 1,
	parameter CREG = 1,
	parameter DREG = 1,
	parameter MREG = 1,
	parameter PREG = 1,
	parameter CARRYINREG = 1,
	parameter CARRYOUTREG = 1,
	parameter OPMODEREG = 1,
	parameter CARRYINSEL = "OPMODE5",
	parameter B_INPUT = "DIRECT",
	parameter RSTTYPE = "SYNC"
	)(
	input [17:0] A, B, D,
	input [47:0] C,
	input [7:0] OPMODE,
	input [17:0] BCIN,
	input [47:0] PCIN,
	input CLK, CARRYIN,
	input RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
	input CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP,
	output [17:0] BCOUT,
	output [47:0] PCOUT, P,
	output [35:0] M,
	output CARRYOUT,
	output CARRYOUTF	
	);
 
	wire [17:0] A0_reg, B0_reg, D_reg, A1_reg, B1_reg;
	wire [47:0] C_reg;
	wire [35:0] M_reg;
	wire [7:0] OPMODE_reg;
	wire [17:0] BINPUT;
	wire [35:0] M_mult;
	wire [17:0] B1_mux;
	wire [47:0] X, Z;
	wire [47:0] X_POST_Z;
	wire CIN, COUT, CARRYIN_mux;
	wire [47:0] M_to_mux;
	wire [17:0] Pre_AS;
	wire [47:0] DAB_concat;
	genvar i;

	assign BINPUT = (B_INPUT == "DIRECT")? B : (B_INPUT == "CASCADE")? BCIN : 0; 
	assign CARRYIN_mux = (CARRYINSEL == "OPMODE5")? OPMODE_reg[5] : (CARRYINSEL == "CARRYIN")? CARRYIN : 0; 
	assign Pre_AS = (OPMODE_reg[6])? D_reg - B0_reg : D_reg + B0_reg;
	assign B1_mux = (OPMODE_reg[4])? Pre_AS : B0_reg;
	assign M_mult = A1_reg * B1_reg;
	assign M_to_mux = {12'b0, M_reg};
	assign DAB_concat = {D[11:0], A1_reg, B1_reg};
	assign X = (OPMODE_reg[1:0] == 0)? 0 : (OPMODE_reg[1:0] == 1)? M_to_mux : (OPMODE_reg[1:0] == 2)? P : {D[11:0], A1_reg, B1_reg};
	assign Z = (OPMODE_reg[3:2] == 0)? 0 : (OPMODE_reg[3:2] == 1)? PCIN : (OPMODE_reg[3:2] == 2)? P : C_reg;
	assign {COUT, X_POST_Z} = (OPMODE_reg[7])? Z-(X+CIN) : Z+X+CIN;
	assign CARRYOUTF = CARRYOUT;
	assign BCOUT = B1_reg;
	assign PCOUT = P;

	generate
  		for (i = 0; i < 36; i = i + 1)
  		begin : buffer
  			buf mbuf(M[i], M_reg[i]);
  		end
	endgenerate

	registered #(.REG(A0REG),
				.INWIDTH(18),
				.RSTTYPE(RSTTYPE)) A0_REG
				(.ce(CEA), .rst(RSTA), .clk(CLK), .in(A), .out(A0_reg));

	registered #(.REG(B0REG),
				.INWIDTH(18),
				.RSTTYPE(RSTTYPE)) B0_REG
				(.ce(CEB), .rst(RSTB), .clk(CLK), .in(BINPUT), .out(B0_reg));

	registered #(.REG(CREG),
				.INWIDTH(48),
				.RSTTYPE(RSTTYPE)) C_REG
				(.ce(CEC), .rst(RSTC), .clk(CLK), .in(C), .out(C_reg));

	registered #(.REG(DREG),
				.INWIDTH(18),
				.RSTTYPE(RSTTYPE)) D_REG
				(.ce(CED), .rst(RSTD), .clk(CLK), .in(D), .out(D_reg));

	registered #(.REG(MREG),
				.INWIDTH(36),
				.RSTTYPE(RSTTYPE)) M_REG
				(.ce(CEM), .rst(RSTM), .clk(CLK), .in(M_mult), .out(M_reg));

	registered #(.REG(OPMODEREG),
				.INWIDTH(8),
				.RSTTYPE(RSTTYPE)) OPMODE_REG
				(.ce(CEOPMODE), .rst(RSTOPMODE), .clk(CLK), .in(OPMODE), .out(OPMODE_reg));

	registered #(.REG(PREG),
				.INWIDTH(48),
				.RSTTYPE(RSTTYPE)) P_REG
				(.ce(CEP), .rst(RSTP), .clk(CLK), .in(X_POST_Z), .out(P));

	registered #(.REG(A1REG),
				.INWIDTH(18),
				.RSTTYPE(RSTTYPE)) A1_REG
				(.ce(CEA), .rst(RSTA), .clk(CLK), .in(A0_reg), .out(A1_reg));

	registered #(.REG(B1REG),
				.INWIDTH(18),
				.RSTTYPE(RSTTYPE)) B1_REG
				(.ce(CEB), .rst(RSTB), .clk(CLK), .in(B1_mux), .out(B1_reg));

	registered #(.REG(CARRYINREG),
				.INWIDTH(1),
				.RSTTYPE(RSTTYPE)) CYI
				(.ce(CECARRYIN), .rst(RSTCARRYIN), .clk(CLK), .in(CARRYIN_mux), .out(CIN));

	registered #(.REG(CARRYOUTREG),
				.INWIDTH(1),
				.RSTTYPE(RSTTYPE)) CYO
				(.ce(1), .rst(0), .clk(CLK), .in(COUT), .out(CARRYOUT));

endmodule