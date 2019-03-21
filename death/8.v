module encoder(fcode, cntrl);
    input [7:0] fcode;
    output [2:0] cntrl;
    reg [2:0] cntrl;
    integer i;
    always@(fcode) begin
      for(i=0; i<8; i=i+1) begin
        if(fcode[i]==1) cntrl = i;
      end
    end
endmodule

module ALU(cntrl, A, B, out);
    input [2:0] cntrl;
    input [3:0] A, B;
    output [3:0] out;
    assign out = (cntrl==0) ? A+B : (cntrl==1) ? A-B : (cntrl==2) ? A^B : (cntrl==3) ? A|B : (cntrl==4) ? A&B : (cntrl==5) ? ~(A|B) : (cntrl==6) ? ~(A&B) : (cntrl==7) ? ~(A^B) : 4'b0000;
endmodule

module EvenParityGen(out, parity);
    output parity;
    input [3:0] out;
    assign parity = ~(^out);
endmodule

module pipeline(parity, aluout, encout, clk, instruction, reset);
    input [15:0] instruction;
    input clk, reset;
    wire [10:0] p1;
    wire [3:0] p2;
    wire [2:0] cntrl;
    output parity;
    output [3:0] aluout;
    output [2:0] encout;
    //fetch stage
    encoder e(instruction[15:8], p1[10:8]);
    assign encout = p1[10:8];
    assign p1[7:4] = instruction[7:4];
    assign p1[3:0] = instruction[3:0];
    //execute stage
    ALU alu(p1[10:8], p1[7:4], p1[3:0], p2);
    assign aluout = p2;
    //parity 
    EvenParityGen epg(p2, parity);
endmodule

module pipeline_test;
    reg reset,clk;
    reg [3:0] A,B;
    reg [7:0] inp_code;
    wire parity;
    wire [2:0] enc_out;
    wire [3:0] alu_out;
    
    pipeline pl(parity,alu_out,enc_out,clk,{inp_code,A,B},reset);
    always @(clk)
      #5 clk<=~clk;
    
    initial
       $monitor($time,"A=%b|B=%b|inp_code=%b|clk=%b||alu_out=%b|enc_out=%b|parity=%b",A,B,inp_code,clk,alu_out,enc_out,parity);  
    initial
       begin
           clk=1'b1;
           reset = 1'b0;
           #10 reset=1'b1;
           #10 A=4'b0001;
               B=4'b1010;
               inp_code= 8'b00000001;
           #10 A=4'b0010;
               B=4'b1010; 
               inp_code= 8'b00010000;
           #10 A=4'b0100;
               B=4'b1010; 
              inp_code= 8'b01000000;
           #10 $finish;
       end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(1, pipeline_test);
    end
endmodule