module ram_16_word (
    output wire [7:0] Q,
    input wire CLK, WE, RE,
    input wire [3:0] RA,
    input wire [3:0] WA,
    input wire [7:0] WD
);
    reg [7:0] Q_reg [0:15];
    always @(posedge CLK) begin
        if (WE) begin
            Q_reg[WA] <= WD;
        end
        else begin
            Q_reg[WA] <= Q_reg[WA];
        end
    end
    assign Q = RE ? Q_reg[RA] : 8'bz;
endmodule

