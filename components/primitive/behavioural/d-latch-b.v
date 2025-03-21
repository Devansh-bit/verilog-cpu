module d_latch (
    input wire D, En,
    output reg Q, Qbar
);
    initial begin
        Q = 0;
        Qbar = 1;
    end
    always @(D or En) begin
        if (En == 1) begin
            Q <= D;
            Qbar <= ~D;
        end
        else begin
            Q <= Q;
            Qbar <= Qbar;
        end
    end
endmodule