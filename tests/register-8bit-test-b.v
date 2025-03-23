module register_8bit_test_b;
    reg [7:0] Data;
    reg clk, load, enable;
    wire [7:0] Q;
    reg_8bit r1 (.Data(Data), .clk(clk), .load(load), .enable(enable), .Q(Q));

    initial begin
        // Initialize inputs
        $monitor("Time: %t, Data: %h, load: %b, enable: %b, Q: %h, clk: %b", $time, Data, load, enable, Q, clk);
        clk = 0;
        Data = 8'b0;
        load = 0;
        enable = 0;

        // Enabled and load data
        #5;
        Data = 8'hAB;
        load = 1;
        enable = 1;
        clk=1;

        #5 
        clk = 0;
        // Enabled and not load data
        #5;
        Data = 8'hCD;
        load = 0;
        enable = 1;
        clk=1;

        #5 clk = 0;

        // Disabled and load data
        #5;
        Data = 8'hEF;
        load = 1;
        enable = 0;
        clk=1;

        #5 clk = 0;

        // Disabled and not load data
        #5;
        Data = 8'h12;
        load = 0;
        enable = 0;
        clk=1;

        #5 clk = 0;

        // Check loaded data
        #5;
        Data = 8'h00;
        load = 0;
        enable = 1;
        clk=1;

        
        // // Test case 1: Load data
        // #10;
        // Data = 8'hAB;
        // load = 1;

        // // Test case 2: Enable and load data
        // #10;
        // enable = 1;
        // load = 1;

        // // Test case 3: Enable and load data
        // #10;
        // enable = 1;
        // load = 0;

        // // Test case 4: Disable and load data
        // #10;
        // enable = 0;
        // load = 1;

        // // Test case 5: Disable and load data
        // #10;
        // enable = 0;
        // load = 0;
        // $finish;
    end
endmodule