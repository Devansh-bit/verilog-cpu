module ALU_simple (
    output wire [7:0] Y,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire SUB
);
    assign Y = SUB ? A - B : A + B;
endmodule