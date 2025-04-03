module controller;

    reg clk_reg, reset, hlt;
    wire clk, controller_clk;
    reg starting;
    initial begin
        clk_reg <= 0;
        hlt <= 0;
        reset <= 0;
        starting <= 1;
        // #20 starting <= 0;
        #1000 $finish; // 10 clock cycles
    end

    always begin 
    #5 clk_reg = ~clk_reg; // 8 ns clock period
    end
    assign clk = (hlt) ? 0 : clk_reg;
    assign controller_clk = (hlt) ? 0 : ~clk_reg; // clock for the controller
    // always begin
    //     if (starting) begin
    //         clk_reg = 0;
    //     end
    //     else begin]
    //         #5 clk_reg = ~clk_reg;
    //     end
    // end

    wire [7:0] bus;

    reg PCOe, PCIe, PCe;
    program_counter pc (
        .Q(bus[3:0]),
        .clk(clk),
        .reset(reset),
        .counter_enable(PCe),
        .output_enable(PCOe),
        .input_enable(PCIe),
        .PC_in(bus[3:0])
    );

    reg MAROe, MARIe;
    wire [3:0] MARo;
    reg_4bit mar (
        .Q(MARo),
        .clk(clk),
        .load(MARIe),
        .output_enable(1'b1),
        .Data(bus[3:0])
    );

    reg RIe, ROe;
    ram_16_word ram (
        .Q(bus),
        .CLK(clk),
        .WE(RIe),
        .RE(ROe),
        .RA(MARo),
        .WA(MARo),
        .WD(bus)
    ); 

    reg IRIe, IROe;
    wire [3:0] IRIo;
    instruction_register ir (
        .IRIo(IRIo),
        .IRAo(bus[3:0]),
        .clk(clk),
        .load(IRIe),
        .output_enable(IROe),
        .Data(bus)
    );

    reg AOe, AIe;
    wire [7:0] Ao;
    cpu_register A (
        .Q_bus(bus),
        .Q(Ao),
        .clk(clk),
        .load(AIe),
        .output_enable(AOe), 
        .Data(bus)
    );
    
    // ALU_simple alu (
    //     .Y(data_out),
    //     .A(data_in),
    //     .B(data_in),
    //     .SUB(sub)
    // );
    
    reg [3:0] state, next_state;
    // cpu internal state synced with inverted clock
    always @(posedge controller_clk) begin

        case (next_state)
            //fetch instruction
            0: begin
                state <= 0;

                ROe <= 0;
                RIe <= 0; 
                IRIe <= 0;
                IROe <= 0;
                PCe <= 0;
                PCIe <= 0;

                PCOe <= 1; // output PC
                MARIe <= 1; // load MAR with PC

                next_state <= 1; // next state
            end

            // decode instruction
            1: begin
                state <= 1;

                PCOe <= 0; // disable PC output
                MARIe <= 0; // disable MAR load

                ROe <= 1; // read from RAM
                IRIe <= 1; // load instruction register with data from RAM
                PCe <= 1; // increment PC

                next_state <= 2; // next state
            end

            // execute instruction
            2: begin
                state <= 2;

                MAROe <= 0; // disable MAR output
                ROe <= 0; // disable RAM read
                IRIe <= 0; // disable instruction register load
                PCe <= 0; // disable PC increment

                // Decode instruction register into different instructions
                // 1: `LDA <Address>` Load A register with data from RAM at given address
                // 2: `ADD <Address>` Add data from RAM at given address to A register and store in A register
                // 3: `SUB <Address>` Subtract data from RAM at given address to A register and store in A register
                // 4: `OUT <Address>` Output data from A register to RAM at given address
                // 15: `HLT` Halt the CPU 
                // 0: `NOP` No operation
                case (IRIo)
                    4'b0001: begin // LDA
                        IROe <= 1; // output instruction register address
                        MARIe <= 1; // load MAR with address from instruction register
                        next_state <= 3; // next state
                    end

                    4'b1111: begin // HLT
                        hlt <= 1; // halt the CPU
                    end
                    default: begin // NOP
                        next_state = 0;
                    end
                endcase
            end

            3: begin
                state <= 3;
                case (IRIo)
                    4'b0001: begin // LDA
                        IROe <= 0; // disable instruction register output
                        MARIe <= 0; // disable MAR load

                        MAROe <= 1; // output MAR
                        ROe <= 1; // read from RAM
                        AIe <= 1; // load A register with data from RAM
                        next_state <= 4; // next state
                    end


                    4'b1111: begin // HLT
                        hlt <= 1; // halt the CPU
                    end
                    default: begin // NOP
                        next_state = 0;
                    end
                endcase
            end

            4: begin
                state <= 4;
                case (IRIo)
                    4'b0001: begin // LDA 
                        MAROe <= 0; // disable MAR output
                        ROe <= 0; // disable RAM read
                        AIe <= 0; // disable A register load
                        next_state <= 0; // next state
                    end


                    4'b1111: begin // HLT
                        hlt <= 1; // halt the CPU
                    end
                    default: begin // NOP
                        state = 0;
                    end
                endcase
            end

            default: begin
                state <= 10; // reset state
                next_state <= 0; // reset state
            end

        endcase
    end

    initial begin
        next_state <= 0;
        PCOe <= 0;
        PCIe <= 0;
        PCe <= 0;
        MAROe <= 0;
        MARIe <= 0;
        RIe <= 0;
        ROe <= 0;
        IRIe <= 0;
        IROe <= 0;
        AOe <= 0;
        AIe <= 0;
        hlt <= 0;
        reset <= 0;
    end


endmodule