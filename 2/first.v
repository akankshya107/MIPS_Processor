module mux1 (a,b,s,f);
	input a,b,s;
	output f;
	assign f = s ? a : b;
endmodule

module testbench;
	reg a,b,s;
	wire f;
	mux1 m(a,b,s,f);
	initial
		begin
		$dumpfile("first.vcd");
			$monitor($time, "a=%b", a);
			#0 a=1'b0;
			#5 a=1'b1;
			#10 $finish;
		end
endmodule
