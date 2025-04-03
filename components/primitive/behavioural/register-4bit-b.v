module reg_4bit (
    output wire [3:0] Q, display,
    input wire clk, load, output_enable,
    input wire [3:0] Data
);
    reg [3:0] Q_reg;
    initial begin
        Q_reg <= 4'bz;
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
    assign Q = (output_enable) ? Q_reg : 4'bz;
endmodule