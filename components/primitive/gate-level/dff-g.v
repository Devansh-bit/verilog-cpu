module dff_g (
    input wire D, clk,
    output wire Q, Qbar  
);    
    wire clkbar, Q1, Q1bar;
    not n1 (clkbar, clk);
    d_latch_g dl1 (D, clkbar, Q1, Q1bar);
    d_latch_g dl2 (Q1, clk, Q, Qbar);
endmodule

