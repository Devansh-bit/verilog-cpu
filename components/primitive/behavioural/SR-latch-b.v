module sr_latch_b (
    input wire S, R,
    output reg Q, Qbar
);
    always @ (S or R)
    begin
        if (S == 1 && R == 0)
        begin
            Q = 1;
            Qbar = 0;
        end
        else if (S == 0 && R == 1)
        begin
            Q = 0;
            Qbar = 1;
        end
        else
        begin
            Q = Q;
            Qbar = Qbar;
        end
    end

endmodule