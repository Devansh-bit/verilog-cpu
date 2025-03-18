module d_latch_g (
    input wire D, En,
    output wire Q, Qbar
);
    wire t1, S, R;
    not n1 (t1, D);
    and a1 (S, t1, En);
    and a2 (R, D, En);
    nor nor1 (Q, S, Qbar);
    nor nor2 (Qbar, R, Q);
endmodule