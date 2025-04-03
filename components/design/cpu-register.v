module cpu_register (
    output wire [7:0] Q_bus, Q,
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
    assign Q_bus = (output_enable) ? Q_reg : 8'bz;
    assign Q = Q_reg;
endmodule