module ram_16_word (
    output wire [7:0] Q,
    input wire CLK, WE, RE,
    input wire [3:0] RA,
    input wire [3:0] WA,
    input wire [7:0] WD
);

    

    reg [7:0] Q_reg [0:15];

    // program for simulation
    initial begin
        Q_reg[0] = 8'b00011110; // LDA 14
        Q_reg[1] = 8'b11110000; // HLT
        Q_reg[14] = 8'b00001100; // Value 12 at add 14
    end

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

