module multicyclecontroller(newstate, PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst, opcode, oldstate);
    input [3:0] oldstate;
    input [5:0] opcode;
    output PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemToReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst;
    output [3:0] newstate;
    reg [3:0] newstate;
    wire [16:0] andArray;

    assign andArray[0] = &(~oldstate);
    
endmodule