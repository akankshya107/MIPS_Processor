module fadder(sum, carry, a, b, c);
	input a, b, c;
	output sum, carry;
	reg sum, carry;
	reg t1;
	
	always@(a or b or c)
	begin
		if(a==0) t1=b;
		else t1=~b;
		
		if(c==0) 
			if(a==0)
				carry=0;
			else 
				carry=b;
		else 
			if(a!=0 || b!=0) carry=1;
			else carry=0;
		if(c==0) sum=t1;
		else sum=~t1;
	end
endmodule

module addsub(s, v, a, b, m);
	input [3:0] a, b;
	input m;
	output [3:0] s;
	output v;
	wire [3:0] temp, c;

	assign temp[0] = b[0] ^ m;
	assign temp[1] = b[1] ^ m;
	assign temp[2] = b[2] ^ m;
	assign temp[3] = b[3] ^ m;
	
	fadder f1(s[0], c[0], a[0], temp[0], m);
	fadder f2(s[1], c[1], a[1], temp[1], c[0]);
	fadder f3(s[2], c[2], a[2], temp[2], c[1]);
	fadder f4(s[3], c[3], a[3], temp[3], c[2]);
	
	assign v = c[2] ^ c[3];
endmodule
	
module testadder;
	reg [3:0] x, y;
	reg m;
	wire [3:0] sum;
	wire overflow;
	
	addsub a(sum, overflow, x, y, m);
	
	initial 
		begin
		$monitor("x=%b, y=%b, m=%b, sum=%b, overflow=%b", x, y, m, sum, overflow);
		#0 x=4'b0111; y=4'b0001; m=1'b0;
		#5 x=4'b1110; y=4'b0001; m=1'b1;
		/*#5 x=8'b01001011; y=8'b01010101; z=1'b0;
		#5 x=8'b10000000; y=8'b01000001; z=1'b0;
		#5 x=8'b10010001; y=8'b01000010; z=1'b0;
		#5 x=8'b00110001; y=8'b00000000; z=1'b0;
		#5 x=8'b01000001; y=8'b01010001; z=1'b0;
		#5 x=8'b00100001; y=8'b11100101; z=1'b0;*/
	end
endmodule
