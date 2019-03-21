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

module reg_32bit(q,d,clk,reset); // Register
    input [31:0] d;
    input clk, reset;
    output [31:0] q;
    genvar j;
    generate for(j=0; j<32; j=j+1) begin: dff_loop
        dff_async d(d[j], reset, clk, q[j]);
        end
    endgenerate
endmodule

module mux4to1_basic(out, sel, in1, in2, in3, in4);
	input in1, in2, in3, in4;
	input [1:0] sel;
	output out;
	wire a,b,c,d,n1,n2,a1,a2,a3,a4;
	
	not n(n1, sel[0]);
	not nn(n2, sel[1]);
	
	and (a1,in4,n1,n2);
	and (a2,in3,n2,sel[0]);
	and (a3,in2,sel[1],n1);
	and (a4,in1,sel[0],sel[1]);
	
	or or1(out,a1,a2,a3,a4);
endmodule

module mux4_1(regData,q1,q2,q3,q4,reg_no);
    input [31:0] q1, q2, q3, q4;
    input [1:0] reg_no;
    output [31:0] regData;
    genvar j;
    generate for(j=0; j<32; j=j+1) begin: muxloop
        mux4to1_basic m(regData[j], reg_no, q1[j], q2[j], q3[j], q4[j]);
        end
    endgenerate
endmodule

module decoder2_4 (register,reg_no);
    input [1:0] reg_no;
    output [3:0] register;
    assign register[0] = ~reg_no[0] && ~reg_no[1];
    assign register[1] = reg_no[0] && ~reg_no[1];
    assign register[2] = ~reg_no[0] && reg_no[1];
    assign register[3] = reg_no[0] && reg_no[1];
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
    input clk, reset, RegWrite;
    input [1:0] ReadReg1, ReadReg2, WriteReg;
    input [31:0] WriteData;
    output [31:0] ReadData1, ReadData2;
    wire [31:0] r0, r1, r2, r3;
    wire [3:0] reg_no;
    wire clk0, clk1, clk2, clk3;
    
    mux4_1 m1(ReadData1, r0, r1, r2, r3, ReadReg1);
    mux4_1 m2(ReadData2, r0, r1, r2, r3, ReadReg2);
    decoder2_4 d(reg_no, WriteReg);
    and a0(clk0, clk, RegWrite, reg_no[0]);
    and a1(clk1, clk, RegWrite, reg_no[1]);
    and a2(clk2, clk, RegWrite, reg_no[2]);
    and a3(clk3, clk, RegWrite, reg_no[3]);
    reg_32bit rW0(r0, WriteData, clk0, reset);
    reg_32bit rw1(r1, WriteData, clk1, reset);
    reg_32bit rw2(r2, WriteData, clk2, reset);
    reg_32bit rw3(r3, WriteData, clk3, reset);
endmodule

module test;
    reg clk, reset, RegWrite;
    reg [1:0] ReadReg1, ReadReg2, WriteReg;
    reg [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
    RegFile R4(clk, reset, ReadReg1, ReadReg2, WriteData, WriteReg, RegWrite, ReadData1, ReadData2);
    always
    #5 clk<=~clk;
    initial begin
    $monitor(, $time, " %b %b %b", ReadData1, ReadData2, WriteData);
    end
    initial begin
      reset=1'b0;
      #5 reset=1'b1; WriteData=32'hAAAAAAAA; WriteReg=2'b00;
      #5 WriteData=32'hAAA3A4AA; WriteReg=2'b01;
      #5 WriteData=32'hAFFFFAAA; WriteReg=2'b10;
      #5 WriteData=32'h0AAEEAAA; WriteReg=2'b11;
      #5 ReadReg1 = 2'b10; ReadReg2 = 2'b11;
      #5 $finish;
    end
endmodule
// module tb32reg;
// reg [31:0] d;
// reg clk,reset;
// wire [31:0] q;
// reg_32bit R(q,d,clk,reset);
// always @(clk)
// #5 clk<=~clk;
// always@(negedge clk) begin
// #1;
// $monitor(, $time, "q=%b, d=%b, reset=%b", q, d, reset);
// end
// initial begin
// clk= 1'b1;
// reset=1'b0;//reset the register
// #20 reset=1'b1;
// #20 d=32'hAFAFAFAF;
// #20 $finish;
// end
// endmodule