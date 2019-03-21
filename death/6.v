module dff_async(d, reset, clock, q);
    input reset, d, clock;
    output q;
    reg q;
    always@(negedge reset or negedge clock)
        begin
          if(!reset) q<= 1'b0;
          else q <=d;
        end
endmodule

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

module InstrMem(address, readData);
    input [4:0] address;
    output [31:0] readData;
    reg [31:0] instructions [31:0];
    integer i;
    initial begin 
        for(i=0; i<32; i=i+1) begin: initial
            instructions[i]=32'h00000000;
        end
    end

    always@(address) begin
      readData = instructions[address];
    end
endmodule

module DataMem(ReadData, ReadReg);
    output [31:0] ReadData;
    input [4:0] ReadReg;
    reg [31:0] data [31:0];
    reg [31:0] ReadData;
    integer i;
    initial begin 
        for(i=0; i<32; i=i+1) begin: initial
            data[i]=32'h00000000;
        end
    end

    always@(ReadReg) begin
      ReadData = data[ReadReg];
    end
endmodule

module PC(q,data,clk,reset);
    input [4:0] data;
    input clk, reset;
    output [4:0] q;

    generate 
        genvar i;
        for(i=0; i<5; i=i+1) begin: pc_loop
            dff_async df(data[i], reset, clk, q[i]);
        end
    endgenerate
endmodule

module SCDataPath();
    input clk, reset;
    input [31:0] data;
    wire [4:0] progc;
    wire [31:0] i;
    PC pc(progc, data, clk, reset);
    InstrMem imem(progc, i);
    ANDarray sigs(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2, i[31:26]);
    controlunit CU(ALUOp1, ALUOp2, i[5:0], out);

endmodule

// RegFile32 rf(clk,reset,rs,rt,ALU_out,rd,RegWrite,Regdata1,Regdata2);
// Andarray controlunit(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
// ALUControl alucontrolunit(aluop,ALUop,op_code[5:0]);
// signExtend se(se_out,op_code[15:0]);
// shiftl2 shiftleft(branch_off,se_out);
// bit32_2to1mux mux1(alusrc2,ALUSrc,Regdata2,branch_off);
// alu ALU(ALU_out,cout,Regdata1,alusrc2,binv,binv,aluop[1:0]);