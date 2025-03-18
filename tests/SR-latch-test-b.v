module test_sr_latch_b;
    reg S, R;
    wire Q, Qbar;

    sr_latch_b latch (
        .S(S),
        .R(R),
        .Q(Q),
        .Qbar(Qbar)
    );

    initial begin
        S = 0; R = 0;
        #1 S = 1; R = 0;
        #1 S = 0; R = 1;
        #1 S = 1; R = 1;
        #1 S = 0; R = 0;
        #1 $finish;
    end
endmodule