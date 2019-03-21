module mux2to1_gate(a,b,s,f);
	input a,b,s;
	output f;
	wire nots, c, d;
	not n1(nots, s);
	and a1(c, nots, a);
	and a2(d, s, b);
	or o1(f, c, d);
endmodule

module mux2to1_df(a,b,s,f);
	input a,b,s;
	output f;
	assign f = s ? a : b;
endmodule

module mux2to1_beh(a,b,s,f);
	input a,b,s;
	output f;
	reg f;
	always@(s or a or b)
		if(s==1) f=a;
		else f=b;
endmodule

module testbench;
	reg a,b,s;
	wire f;
	mux2to1_gate mux_gate (a,b,s,f);
	initial
		begin
		  $dumpfile("1.vcd");
		  $dumpvars(0, testbench);
		  $monitor(, $time, " a=%b, b=%b, s=%b, f=%b", a,b,s,f);
		  #0 a=1'b0; b=1'b1;
		  #2 s=1'b1;
		  #5 s=1'b0;
		  #10 a=1'b1;b=1'b0;
		  #15 s=1'b1;
		  #20 s=1'b0;
		  #100 $finish;
		end
endmodule