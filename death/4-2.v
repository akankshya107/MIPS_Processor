module ANDarray(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
	input [5:0] Op;
	output RegDst,ALUSrc,MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2;
	wire Rformat, lw,sw,beq;
	assign Rformat= (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
	assign lw=Op[0] & Op[1] & (~Op[2])& (~Op[3])& (~Op[4]) & Op[5];
	assign sw=Op[5] & ~(Op[4]) & Op[3] & ~(Op[2]) & Op[1] & Op[0];
	assign beq=(~Op[0])& (~Op[1])& (Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
	
	assign RegDst=Rformat;
	assign ALUSrc=lw | sw;
	assign MemtoReg=lw;
	assign RegWrite=Rformat|lw;
	assign MemRead=lw;
	assign MemWrite=sw;
	assign Branch=beq;
	assign ALUOp1=Rformat;
	assign ALUOp2=beq;
	
endmodule

module controlunit(ALUOp1, ALUOp2, f, out);
	input ALUOp1, ALUOp2;
	input [5:0] f;
	output [2:0] out;
	assign out[0] = (f[3] || f[0]) && ALUOp2;
	assign out[1] = ~(f[2]&&ALUOp2);
	assign out[2] = (f[1] && ALUOp2) || ALUOp1;
endmodule
	
    