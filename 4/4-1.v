//ALL DA MUXS
module mux2to1(out,sel,in1,in2);
	input in1, in2, sel;
	output out;
	wire not_sel, a1, a2;
	not(not_sel, sel);
	and(a1, sel, in2);
	and(a2, not_sel, in1);
	or(out, a1, a2);
endmodule

module mux4to1(out, sel, in1, in2, in3, in4);
	input in1, in2, in3, in4;
	input [1:0] sel;
	output out;
	wire a,b,c,d,n1,n2,a1,a2,a3,a4;
	
	not n(n1, sel[0]);
	not nn(n2, sel[1]);
	
	and (a1,in1,n1,n2);
	and (a2,in2,n2,sel[0]);
	and (a3,in3,sel[1],n1);
	and (a4,in4,sel[0],sel[1]);
	
	or or1(out,a1,a2,a3,a4);
endmodule


module bit8_2to1mux(out, sel, in1, in2);
	input [7:0] in1, in2;
	output [7:0] out;
	input sel;
	genvar j;
	//generate block
	generate for (j=0; j<8; j=j+1) begin: mux_loop
		mux2to1 m1(out[j], sel, in1[j], in2[j]);
	end
	endgenerate
endmodule

module bit32_8to1mux(out, sel, in1, in2);
	input [31:0] in1, in2;
	output [31:0] out;
	input sel;
	genvar j;
	//generate block
	generate for (j=0; j<4; j=j+1) begin: mux_loop
		bit8_2to1mux m1(out[j*8 +7:j*8], sel, in1[j*8 +7:j*8], in2[j*8 +7:j*8]);
	end
	endgenerate
endmodule

module bit32_4to1mux(out, sel, in1, in2, in3);
	input [1:0] sel;
	input [31:0] in1, in2, in3;
	output [31:0] out;
	genvar j;
	generate for (j=0; j<32; j=j+1) begin: mux_loop
		mux4to1 m1(out[j], sel, in1[j], in2[j], in3[j], 1'b0);
	end
	endgenerate
endmodule

//AND+OR gates to be found here
module bit32and(out, in1, in2);
	input [31:0] in1, in2;
	output [31:0] out;
	assign {out}=in1 & in2;
endmodule

module bit32or(out, in1, in2);
	input [31:0] in1, in2;
	output [31:0] out;
	assign {out}=in1 | in2;
endmodule

//Full adder for 32 bits
module FA_dataflow (Cout, Sum,In1,In2,Cin);
 input [31:0] In1,In2;
 input Cin;
 output Cout;
 output [31:0] Sum;
 assign {Cout,Sum}=In1+In2+Cin;
endmodule 

module ALU(in1, in2, bin, cin, op, res, cout);
	input bin, cin;
	input [31:0] in1, in2;
	input [1:0] op;
	output [31:0] res;
	output cout;
	wire [31:0] andop, orop, addsubop, mod, bexpand;
	genvar i;
	bit32and band(andop, in1, in2);
	bit32or bor(orop, in1, in2);
	assign bexpand = 32{bin};
	assign mod = bexpand^in2;
	// generate for (i=0; i<32; i=i+1) begin: twoscomplement
	// 	assign mod[i]=bin^in2[i];
	// end
	// endgenerate
	FA_dataflow fad(cout, addsubop, in1, mod, bin);
	bit32_4to1mux mux(res, op, andop, orop, addsubop);
endmodule

module tbALU;
	reg Binvert, Carryin;
	reg [1:0] Operation;
	reg [31:0] a,b;
	wire [31:0] Result;
	wire CarryOut;
	ALU alu(a,b,Binvert,Carryin,Operation,Result,CarryOut);
	initial 
	$monitor($time, " a=%b, b=%b, bin=%b, cin=%b, op=%b, res=%b, cout=%b", a,b,Binvert,Carryin,Operation,Result,CarryOut);
	initial
		begin
		a=32'ha5a5a5a5;
		b=32'h5a5a5a5a;
		Operation=2'b00;
		Binvert=1'b0;
		Carryin=1'b0; //must perform AND resulting in zero
		#100 Operation=2'b01; //OR
		#100 Operation=2'b10; //ADD
		#100 Binvert=1'b1;//SUB
		#200 $finish;
	end
endmodule

/*module tb32bitadd;
	reg [31:0] IN1,IN2;
	reg CIN;
	wire [31:0] OUT;
	wire COUT;
	FA_dataflow a1 (COUT,OUT,IN1,IN2, CIN);
	initial
	$monitor($time, "inp1=%b, inp2=%b, out=%b, cin=%b, cout=%b", IN1, IN2, OUT, CIN, COUT);
	initial begin
	IN1=32'h1005;
	IN2=32'h1001;
	CIN=1'b0;
	#100 IN1=32'h5A5A;
	#400 $finish;
	end
endmodule
*/

/*module tb32bitlogix;
	reg [31:0] IN1,IN2;
	wire [31:0] OUT;
	bit32or a1 (OUT,IN1,IN2);
	initial
	$monitor($time, "inp1=%b, inp2=%b, out=%b", IN1, IN2, OUT);
	initial begin
	IN1=32'hA5A5;
	IN2=32'h5A5A;
	#100 IN1=32'h5A5A;
	#400 $finish;
	end
endmodule
*/

/*module test32bitmux;
	reg [31:0] inp1, inp2, inp3;
	reg [1:0] sel;
	wire [31:0] out;
	
	bit32_4to1mux b(out, sel, inp1, inp2, inp3);
	
	initial
	$monitor($time, "inp1=%b, inp2=%b, inp3=%b, out=%b, sel=%b", inp1, inp2, inp3, out, sel);
	
	initial 
		begin
			inp1=32'b01010101010101010101010101010101;
			inp2=32'b10101011101010111010101110101011;
			inp3=32'b11111111111111111111111111111111;
			sel=2'b00;
			#100 sel=2'b10;
			#1000 $finish;
		end
endmodule*/