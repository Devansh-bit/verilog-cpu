module sr_latch_g(
    input S, R,
    output Q, Qbar
);
    nor n1(Q, S, Qbar);
    nor n2(Qbar, R, Q);
endmodule