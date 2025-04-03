module simple_ALU (
    output wire [7:0] Y,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire SUB,
    input wire enable
);
    wire [7:0] Y_reg;
    assign Y_reg = SUB ? A - B : A + B;
    assign Y = (enable) ? Y_reg : 8'bz;
endmodule
