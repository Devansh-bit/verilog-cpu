module test_dff_g;
    reg D, clk;
    wire Q, Qbar;
    dff dff1 (D, clk, Q, Qbar);
    initial begin
        // $dumpfile("edge_detector_posedge_g_tb.vcd");
        // $dumpvars(0, edge_detector_posedge_g_tb);
        $monitor("D=%b, clk=%b, Q=%b", D, clk, Q);
        D = 0; clk = 0;
        #5 D = 1;
        #5 clk = 1;
        #5 D = 0;
        #5 clk = 0;
        #10 clk = 1;
        #10 clk = 0;
        #10 clk = 1;
        #10 clk = 0;
        #10 clk = 1;
        #10 clk = 0;
        #10 clk = 1;
    end
endmodule