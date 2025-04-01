module reg_8bit_g (
    output wire [7:0] Q,
    input wire clk, load, enable,
    input wire [7:0] Data
);
    wire [7:0] Q_reg;
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin
            dff_g dff1 (
                .D(Data[i]),
                .clk(clk),
                .Q(Q_reg[i]),
                .Qbar()
            );
             bufif1 buf1 (
                 Q[i],
                 Q_reg[i],
                 enable
             );
        end
    endgenerate
endmodule