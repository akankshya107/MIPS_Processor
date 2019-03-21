module dff_async(d, reset, clock, q);
    input reset, d, clock;
    output q;
    reg q;
    always@(posedge reset or posedge clock)
        begin
          if(reset) q<= 1'b0;
          else q <=d;
        end
endmodule

module test;
    reg d, clk, rst;
    wire q;

    dff_async dff(d, rst, clk, q);

    always@(posedge clk) begin
	#1 ;
	$display($time, " d=%b, clk=%b, rst=%b, q=%b\n", d, clk, rst, q);
	end
    initial begin
		forever begin
		clk=0;
		#5 clk=1;
		#5 clk=0;
		end
	end

    initial begin
      d=0; rst=1;
      #4 d=1; rst=0;
      #50 d=1; rst=1;
      #20 d=1; rst=0;
      #10 $finish;
    end
endmodule