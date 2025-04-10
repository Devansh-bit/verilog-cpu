module reg_8bit (
    output wire [7:0] Q,
    input wire clk, load, output_enable,
    input wire [7:0] Data
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
    assign Q = (output_enable) ? Q_reg : 8'bz;
endmodule