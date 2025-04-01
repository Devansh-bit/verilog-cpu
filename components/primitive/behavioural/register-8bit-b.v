module reg_8bit (
    output wire [7:0] Q,
    input wire [7:0] Data,
    input wire clk, load, enable
);
    reg [7:0] Q_reg;
    initial begin
        Q_reg <= 8'b0;
    end
    always @(posedge clk) begin
        if (load) begin
            Q_reg <= Data;
        end
        else begin
            Q_reg <= Q_reg;
        end
    end
    assign Q = enable ? Q_reg : 8'bz;
endmodule