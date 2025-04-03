module program_counter (
    output wire [3:0] Q,
    input wire clk,
    input wire reset,
    input wire counter_enable,
    input wire output_enable,
    input wire input_enable,
    input wire [3:0] PC_in
);
    reg [3:0] PC;
    assign Q = (output_enable) ? PC : 4'bz;

    initial begin
        PC <= 4'b0000;
    end

    always @(reset) begin
        if (reset) begin
            PC <= 4'b0000;
        end
        else begin
            PC <= PC;
        end
    end

    always @(posedge clk) begin
        if (counter_enable) begin
            PC <= PC + 1;
        end
        else if (input_enable) begin
            PC <= PC_in;
        end
        else begin
            PC <= PC;
        end
    end

endmodule

// Testbench for program_counter module
module test_program_counter;
    reg clk, reset, counter_enable, output_enable, input_enable;
    reg [3:0] PC_in;
    wire [3:0] Q;

    program_counter pc (
        .Q(Q),
        .clk(clk),
        .reset(reset),
        .counter_enable(counter_enable),
        .output_enable(output_enable),
        .input_enable(input_enable),
        .PC_in(PC_in)
    );

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        counter_enable = 0;
        output_enable = 0;
        input_enable = 0;
        PC_in = 4'b0000;

        // Monitor output
        $monitor("Time: %0t | Q: %b | clk: %b | reset: %b | counter_enable: %b | output_enable: %b | input_enable: %b | PC_in: %b", $time, Q, clk, reset, counter_enable, output_enable, input_enable, PC_in);
        // Test reset functionality
        #5 reset = 1; // Assert reset
        #5 reset = 0; // Deassert reset

        // Test counter enable functionality
        #5 counter_enable = 1; // Enable counter
        clk = 1; // Toggle clock
        output_enable = 1; // Enable output
        #5 clk = 0; // Toggle clock
        #5 clk = 1; // Toggle clock
        #5 clk = 0; // Toggle clock
        output_enable = 0; // Disable output
        counter_enable = 0; // Disable counter
        #5 clk = 1; // Toggle clock
        output_enable = 1; // Enable output
        #5 clk = 0; // Toggle clock
        output_enable = 0; // Disable output
    end
endmodule