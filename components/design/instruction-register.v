module instruction_register (
    output wire [3:0] IRAo, IRIo,
    output wire [7:0] display,
    input wire clk, load, output_enable,
    input wire [7:0] Data
);
    reg [7:0] Q_reg;
    initial begin
        Q_reg <= 8'bz;
    end
    always @(posedge clk) begin
        if (load) begin
            Q_reg <= Data;
        end
        else begin
            Q_reg <= Q_reg;
        end
    end
    assign display = Q_reg;
    assign IRIo = Q_reg[7:4];
    assign IRAo = (output_enable) ? Q_reg[3:0] : 4'bz;
endmodule