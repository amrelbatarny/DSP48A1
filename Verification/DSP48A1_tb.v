module DSP48A1_tb();
	reg [17:0] A, B, D;
	reg [47:0] C;
	reg [7:0] OPMODE;
	reg [17:0] BCIN;
	reg [47:0] PCIN;
	reg CLK, CARRYIN;
	reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
	reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
	wire [17:0] BCOUT;
	wire [47:0] PCOUT, P;
	wire [35:0] M;
	wire CARRYOUT;
	wire CARRYOUTF;

	//Inputs being operated on (forced inputs in the first clock cycle)
	reg [17:0] A_op, B_op, D_op, BCIN_op, BCOUT_op;
	reg [47:0] C_op, PCIN_op;
	reg [35:0] M_op;
	reg [7:0] OPMODE_op;
	reg CARRYIN_op;
	reg [47:0] DAB_concat_op;

	//Expected outputs
	reg [17:0] BCOUT_exp;
	reg [35:0] M_exp;
	reg [48:0] COUTandP_exp;
	reg [48:0] X_POST_Z;
	reg [47:0] P_exp;
	reg CARRYOUT_exp;

	//Instantiating the DUT module
	DSP48A1 DUT(A, B, D, C, OPMODE, BCIN, PCIN ,CLK, CARRYIN, RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE,
				RSTP, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

	//Implementing the clock
	initial begin
		CLK = 0;
		forever
			#10 CLK = ~CLK;
	end

	//Generating stimulus and comparing outputs and their corresponding expected outputs
	initial begin
		//Initializing the module by reseting everything
		{RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 8'hFF;
		{CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP} = 0;
		repeat(2) @(negedge CLK);

		//Starting testing
		{RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 0;
		{CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP} = 8'hFF;

		//Test case(1): the execution passes through 4 pipelines (4 clock cycles), where OPMODE[1:0] = 2'b01
		repeat(5000) begin
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = 8'b1111_1101;
	
			//operating inputs are the forced inputs in the first clock cycle to be operated on in the upcoming cycles
			A_op = A;
			B_op = B;
			C_op = C;
			D_op = D;
			PCIN_op = PCIN;
			BCIN_op = BCIN;
			CARRYIN_op = CARRYIN;
			OPMODE_op = OPMODE;
	
			@(posedge CLK);
			BCOUT_exp = D_op - B_op;
			repeat(2) @(negedge CLK);
			if(BCOUT != BCOUT_exp) begin
				$display("Error - Incorrect BCOUT, BCOUT_tb = %d, BCOUT_expected = %d", BCOUT, BCOUT_exp);
				$stop;
			end
			
			BCOUT_op = BCOUT;
	
			@(posedge CLK);
			M_exp = BCOUT_op * A_op;
	
			@(negedge CLK);
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = $random;
	
			if(M != M_exp) begin
				$display("Error - Incorrect M, M_tb = %d, M_expected = %d", M, M_exp);
				$stop;
			end
	
			M_op = M;
	
			@(posedge CLK);
			COUTandP_exp = C_op-(M_op+OPMODE_op[5]);
			P_exp = COUTandP_exp[47:0];
			CARRYOUT_exp = COUTandP_exp[48];
	
			@(negedge CLK);
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = $random;
	
			if(P != P_exp) begin
				$display("Error - Incorrect P, P_tb = %d, P_exp = %d", P, P_exp);
				$stop;
			end
			if(CARRYOUT != CARRYOUT_exp) begin
				$display("Error - Incorrect P, CARRYOUT_tb = %d, CARRYOUT_exp = %d", CARRYOUT, CARRYOUT_exp);
				$stop;
			end
		end
		$display("Test case (1) BCOUT after 2 clock cycles, M after 3 clock cycles, P after 4 clock cycles(X = M_reg)\n");

		//Test case(2): the execution passes through 3 pipelines (3 clock cycles), where OPMODE[1:0] = 2'b11
		repeat(5000) begin
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = 8'b1111_1111;
	
			//operating inputs are the forced inputs in the first clock cycle to be operated on in the upcoming cycles
			A_op = A;
			B_op = B;
			C_op = C;
			D_op = D;
			PCIN_op = PCIN;
			BCIN_op = BCIN;
			CARRYIN_op = CARRYIN;
			OPMODE_op = OPMODE;
	
			@(posedge CLK);
			BCOUT_exp = D_op - B_op;
			repeat(2) @(negedge CLK);
			if(BCOUT != BCOUT_exp) begin
				$display("Error - Incorrect BCOUT, BCOUT_tb = %d, BCOUT_expected = %d", BCOUT, BCOUT_exp);
				$stop;
			end
			
			BCOUT_op = BCOUT;
			DAB_concat_op = {D_op[11:0], A_op, BCOUT_op};
			
			@(posedge CLK);
			M_exp = BCOUT_op * A_op;
			COUTandP_exp = C_op-(DAB_concat_op+OPMODE_op[5]);
			P_exp = COUTandP_exp[47:0];
			CARRYOUT_exp = COUTandP_exp[48];
	
			@(negedge CLK);
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = $random;
	
			if(M != M_exp) begin
				$display("Error - Incorrect M, M_tb = %d, M_expected = %d", M, M_exp);
				$stop;
			end
			if(P != P_exp) begin
				$display("Error - Incorrect P, P_tb = %d, P_exp = %d", P, P_exp);
				$stop;
			end
			if(CARRYOUT != CARRYOUT_exp) begin
				$display("Error - Incorrect P, CARRYOUT_tb = %d, CARRYOUT_exp = %d", CARRYOUT, CARRYOUT_exp);
				$stop;
			end
		end
		$display("Test case (2) BCOUT after 2 clock cycles, M after 3 clock cycles, P after 3 clock cycles(X = D:A:B)\n");

		//Test case(3): P gets an initial value after the first 3 cycles and then gets updated every clock cycle(X = P)
		repeat(5000) begin
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = 8'b1111_1110;
	
			//operating inputs are the forced inputs in the first clock cycle to be operated on in the upcoming cycles
			A_op = A;
			B_op = B;
			C_op = C;
			D_op = D;
			PCIN_op = PCIN;
			BCIN_op = BCIN;
			CARRYIN_op = CARRYIN;
			OPMODE_op = OPMODE;
	
			@(posedge CLK);
			BCOUT_exp = D_op - B_op;
			repeat(2) @(negedge CLK);
			if(BCOUT != BCOUT_exp) begin
				$display("Error - Incorrect BCOUT, BCOUT_tb = %d, BCOUT_expected = %d", BCOUT, BCOUT_exp);
				$stop;
			end
			
			BCOUT_op = BCOUT;
			DAB_concat_op = {D_op[11:0], A_op, BCOUT_op};
			X_POST_Z = C_op-(P+OPMODE_op[5]);

			@(posedge CLK);
			M_exp = BCOUT_op * A_op;
			COUTandP_exp = X_POST_Z;
			P_exp = COUTandP_exp[47:0];
			CARRYOUT_exp = COUTandP_exp[48];

	
			@(negedge CLK);
			A = $random;
			B = $random;
			C = $random;
			D = $random;
			PCIN = $random;
			BCIN = $random;
			CARRYIN = $random;
			OPMODE = $random;
	
			if(M != M_exp) begin
				$display("Error - Incorrect M, M_tb = %d, M_expected = %d", M, M_exp);
				$stop;
			end
			if(P != P_exp) begin
				$display("Error - Incorrect P, P_tb = %d, P_exp = %d", P, P_exp);
				$stop;
			end
			if(CARRYOUT != CARRYOUT_exp) begin
				$display("Error - Incorrect P, CARRYOUT_tb = %d, CARRYOUT_exp = %d", CARRYOUT, CARRYOUT_exp);
				$stop;
			end
		end
		$display("Test case (3) P gets an initial value after the first 3 cycles and then gets updated every clock cycle(X = P)\n");

		$display("DSP48A1 is successfully verified");
		$stop;
	end
endmodule