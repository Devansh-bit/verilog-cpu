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