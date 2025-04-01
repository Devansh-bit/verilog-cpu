module controller (
    input wire clk,
    input wire reset,
    // input wire [7:0] data_in,
    // output wire [7:0] data_out,
    // output wire [3:0] operation
);
    reg sub, RIe, ROe;
    reg [3:0] RRA, RWA;
    reg [7:0] RWD;
    reg [7:0] A, B;
    wire [7:0] bus;
    reg [3:0] state;
    reg [3:0] IR, PC;

    ram_16_word ram (
        .Q(bus),
        .CLK(clk),
        .WE(RIe),
        .RE(ROe),
        .RA(bus[3:0]),
        .WA(bus[3:0]),
        .WD(R)
    ); 
    
    // ALU_simple alu (
    //     .Y(data_out),
    //     .A(data_in),
    //     .B(data_in),
    //     .SUB(sub)
    // );
    
    initial begin
        PC = 0;
        IR = 0;
        A = 0;
        B = 0;
        RRA = 0;
        RWA = 0;
        RWD = 0;
        RIe = 0;
        ROe = 0;
        sub = 0;
        enable = 0;
    end

    
    always @(posedge clk) begin
        // begin state transfer
        // posedge shift
        // 1. fetch instruction

        case (state)
            0: begin
                

            end
        endcase

        // 2. decode instruction
        // 3. execute instruction


        // 4 bit counter 6 Instructions
        // last bit reset counter
        // Doubt: how to change control config for each instruction
    end


endmodule