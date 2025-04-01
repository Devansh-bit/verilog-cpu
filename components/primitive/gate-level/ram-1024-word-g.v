module ram_1024_word_g (
    output wire [7:0] Q,
    input wire CLK, WE, RE,
    input wire [9:0] RA,
    input wire [9:0] WA,
    input wire [7:0] WD
);
    wire [7:0] Q_reg [1023:0];
    wire [1023:0] decoder_out_RE, decoder_out_WE;
    assign decoder_out_RE = (1024'b1 << RA);
    assign decoder_out_WE = (1024'b1 << WA);
    generate
        genvar i;
        for (i = 0; i < 1024; i = i + 1) begin
            reg_8bit reg1 (
                .Q(Q_reg[i]),
                .clk(CLK),
                .load(decoder_out_WE[i]),
                .enable(decoder_out_RE[i]),
                .Data(WD)
            );
        end
    endgenerate
    assign Q = Q_reg[RA];
    
    
endmodule