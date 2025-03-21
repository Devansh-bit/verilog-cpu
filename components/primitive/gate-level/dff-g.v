module dff_g (
    input wire D, clk,
    output wire Q, Qbar  
);    
    wire clkbar, Q1, Q1bar;
    not n1 (clkbar, clk);
    d_latch_g dl1 (D, clkbar, Q1, Q1bar);
    d_latch_g dl2 (Q1, clk, Q, Qbar);
    always @(D or clk or Q1 or Q) begin
        //$display("time=%d, clk=%b\nFrom dlatch1 D=%b, Q1=%b\nFrom dlatch2 D2=%b, Q2=%b\n\n", $time, clk, D, Q1, Q1, Q);
    end
endmodule

