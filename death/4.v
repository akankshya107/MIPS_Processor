module test;
reg a,b,c,d;
initial
    begin
        $display($time, "a=%b, b=%b\n", a, b);
        fork
            #5 a = 1'b1;
            #10 b = 1'b0;
            #15 c = 1'b1;
        join
        #30 d = 1'b0;
    end
endmodule