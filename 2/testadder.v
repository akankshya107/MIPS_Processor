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

module adder8(sum, carry, a, b, cin);
	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output carry;
	wire [6:0] c;
	
	fadder f1(sum[0], c[0], a[0], b[0], cin);
	fadder f2(sum[1], c[1], a[1], b[1], c[0]);
	fadder f3(sum[2], c[2], a[2], b[2], c[1]);
	fadder f4(sum[3], c[3], a[3], b[3], c[2]);
	fadder f5(sum[4], c[4], a[4], b[4], c[3]);
	fadder f6(sum[5], c[5], a[5], b[5], c[4]);
	fadder f7(sum[6], c[6], a[6], b[6], c[5]);
	fadder f8(sum[7], carry, a[7], b[7], c[6]);
endmodule

module adder32(sum, carry, a, b, cin);
	input [31:0] a, b;
	input cin;
	output [31:0] sum;
	output carry;
	wire [2:0] c;
	
	adder8 f1(sum[7:0], c[0], a[7:0], b[7:0], cin);
	adder8 f2(sum[15:8], c[1], a[15:8], b[15:8], c[0]);
	adder8 f3(sum[23:16], c[2], a[23:16], b[23:16], c[1]);
	adder8 f4(sum[31:24], carry, a[31:24], b[31:24], c[2]);
endmodule

module testadder;
	reg [31:0] x, y;
	reg z;
	wire [31:0] sum;
	wire carry;
	
	adder32 a(sum, carry, x, y, z);
	
	initial 
		begin
		$monitor("x=%b, y=%b, z=%b, sum=%b, carry=%b", x, y, z, sum, carry);
		#0 x=32'b00110000111000001110000011100000; y=32'b00100010010101010101010101010101; z=1'b0;
		/*#5 x=8'b11100000; y=8'b00010000; z=1'b0;
		#5 x=8'b01001011; y=8'b01010101; z=1'b0;
		#5 x=8'b10000000; y=8'b01000001; z=1'b0;
		#5 x=8'b10010001; y=8'b01000010; z=1'b0;
		#5 x=8'b00110001; y=8'b00000000; z=1'b0;
		#5 x=8'b01000001; y=8'b01010001; z=1'b0;
		#5 x=8'b00100001; y=8'b11100101; z=1'b0;*/
	end
endmodule