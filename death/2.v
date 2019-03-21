module mux4to1(out, in, sel);
    input[3:0] in;
    input[1:0] sel;
    output out;
    wire not1, not2, out1, out2, out3, out4;

    not n1(not1, sel[0]);
    not n2(not2, sel[1]);
    and a1(out1, in[0], not1, not2);
    and a2(out2, in[1], sel[0], not2);
    and(out3, in[2], not1, sel[1]);
    and(out4, in[3], sel[0], sel[1]);
    or(out, out1, out2, out3, out4);
endmodule

module decoder(out, x, y, z);
	input x, y, z;
	output [7:0] out;
	wire [2:0] rev;
	
	not n1(rev[0], x);
	not n2(rev[1], y);
	not n3(rev[2], z);
	
	and a1(out[0], rev[0], rev[1], rev[2]);
	and a2(out[1], rev[0], rev[1], z);
	and a3(out[2], rev[0], y, rev[2]);
	and a4(out[3], rev[0], y, z);
	and a5(out[4], x, rev[1], rev[2]);
	and a6(out[5], x, rev[1], z);
	and a7(out[6], x, y, rev[2]);
	and a8(out[7], x, y, z);
endmodule

module fadder(sum, carry, x, y, z);
	input x, y, z;
	output sum, carry;
	wire [7:0] temp;
	
	decoder dec(temp, x, y, z);
	
	assign sum = temp[1] | temp[2] | temp[4] | temp[7];
	assign carry = temp[3] | temp[5] | temp[6] | temp[7];
endmodule

module adder8(a, b, cin, sum, carry);
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output carry;
    wire [6:0] c;
    fadder f1(out[0], c, a[0], b[0], cin);
    fadder f2(out[1], c, a[1], b[1], c);