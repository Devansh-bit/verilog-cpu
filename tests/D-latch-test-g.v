module test_d_latch_g;
    reg D, CLK;
    wire Q, Qbar;

    d_latch_g latch (
        .D(D),
        .En(CLK),
        .Q(Q),
        .Qbar(Qbar)
    );

    initial begin
        $monitor(D, CLK, Q, Qbar);
        D = 0; CLK = 0;
        #1 D = 1; CLK = 0;
        #1 D = 0; CLK = 1;
        #1 D = 1; CLK = 0;
        #1 D = 0; CLK = 0;
        #1 D = 1; CLK = 1;
        #1 D = 1; CLK = 0;
        #1 D = 0; CLK = 0;
        #1 $finish;
    end
endmodule