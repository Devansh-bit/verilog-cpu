module dff (
    input wire D, clk,
    output reg Q, Qbar  
);   
    initial begin
        Q <= 0;
        Qbar <= 1;
    end
    always @(posedge clk) begin
        Q <= D;
        Qbar <= ~D;
    end
endmodule