module ALU (
    output wire [7:0] Y,
    input wire [3:0] operation,
    input wire [7:0] A, B,
    input wire OE, Op
);
    
    reg [7:0] Y_reg;
    always @(A, B, operation) begin
        case (operation)
            4'b0000: Y_reg <= A + B;
            4'b0001: Y_reg <= A - B;
            4'b0010: Y_reg <= A & B;
            4'b0011: Y_reg <= A | B;
            4'b0100: Y_reg <= A ^ B;
            4'b0101: Y_reg <= A << B;
            4'b0110: Y_reg <= A >> B;
            4'b0111: Y_reg <= ~A;
            default: Y_reg <= 8'bz;
        endcase
    end
    assign Y = (enable) ? Y_reg : 8'bz;
endmodule