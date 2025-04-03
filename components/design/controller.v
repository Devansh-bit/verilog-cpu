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
    assign controller_clk = (hlt) ? 0 : ~clk_reg;

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

    reg MARIe;
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

    reg BOe, BIe;
    wire [7:0] Bo;
    cpu_register B (
        .Q_bus(bus),
        .Q(Bo),
        .clk(clk),
        .load(BIe),
        .output_enable(BOe), 
        .Data(bus)
    );
    
    reg sub, ALUOe;
    simple_ALU alu (
        .Y(bus),
        .A(Ao),
        .B(Bo),
        .SUB(sub),
        .enable(ALUOe)
    );

    wire [7:0] leds;
    reg ORIe;
    reg_8bit output_register (
        .Q(leds),
        .clk(clk),
        .load(ORIe),
        .output_enable(1'b1),
        .Data(bus)
    );
    
    reg [3:0] state, next_state;
    // cpu internal state synced with inverted clock
    always @(posedge controller_clk) begin

        case (next_state)
            //fetch instruction
            0: begin
                state <= 0;

                // default values
                PCIe <= 0;
                PCe <= 0;
                RIe <= 0;
                ROe <= 0;
                IRIe <= 0;
                IROe <= 0;
                AOe <= 0;
                AIe <= 0;
                BOe <= 0;
                BIe <= 0;
                sub <= 0;
                ALUOe <= 0;
                ORIe <= 0;

                // Program Counter -> Memory Address Register
                PCOe <= 1; 
                MARIe <= 1; 

                next_state <= 1; // next state
            end

            // decode instruction
            1: begin
                state <= 1;

                PCOe <= 0;
                MARIe <= 0;

                // RAM to Instruction Register
                ROe <= 1; 
                IRIe <= 1; 
                PCe <= 1; // increment program counter

                next_state <= 2; // next state
            end

            // execute instruction
            2: begin
                state <= 2;

                ROe <= 0;
                IRIe <= 0;
                PCe <= 0;

                // Decode instruction register into different instructions
                // 1: `LDA <Address>` Load A register with data from RAM at given address
                // 2: `ADD <Address>` Add data from RAM at given address to A register and store in A register
                // 3: `SUB <Address>` Subtract data from RAM at given address to A register and store in A register
                // 4: `OUT <Address>` Output data from A register to RAM at given address
                // 5: `JMP <Address>` Jump to given address in RAM
                // 15: `HLT` Halt the CPU 
                // 0: `NOP` No operation
                case (IRIo)
                    4'b0001: begin // LDA
                        // Instruction register to Memory Address Register
                        IROe <= 1; 
                        MARIe <= 1; 
                        next_state <= 3; // next state
                    end

                    4'b0010: begin //ADD
                        // Instruction register to Memory Address Register
                        IROe <= 1; 
                        MARIe <= 1; 
                        next_state <= 3; // next state
                    end

                    4'b0011: begin // SUB
                        // Instruction register to Memory Address Register
                        IROe <= 1; 
                        MARIe <= 1; 
                        next_state <= 3; // next state
                    end

                    4'b0100: begin // OUT
                        // Instruction register to Memory Address Register
                        IROe <= 1; 
                        MARIe <= 1; 
                        next_state <= 3; // next state
                    end

                    4'b1111: begin // HLT
                        hlt <= 1; 
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
                        IROe <= 0; 
                        MARIe <= 0; 
                        // RAM to A register
                        ROe <= 1; 
                        AIe <= 1; 
                        next_state <= 4; // next state
                    end

                    4'b0010: begin // ADD
                        IROe <= 0; 
                        MARIe <= 0; 
                        // RAM to B register
                        ROe <= 1; 
                        BIe <= 1;
                        sub <= 0; // addition
                        next_state <= 4; // next state
                    end

                    4'b0011: begin // SUB
                        IROe <= 0; 
                        MARIe <= 0; 
                        // RAM to B register
                        ROe <= 1; 
                        BIe <= 1;
                        sub <= 1; // subtraction
                        next_state <= 4; // next state
                    end

                    4'b0100: begin // OUT
                        IROe <= 0;
                        MARIe <= 0;
                        // A register to RAM
                        AOe <= 1;
                        RIe <= 1;
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

                        // Reset for next instruction
                        ROe <= 0; 
                        AIe <= 0; 
                        next_state <= 0; // next state
                    end

                    4'b0010: begin // ADD
                        ROe <= 0;
                        BIe <= 0;

                        // ALU to A register
                        ALUOe <= 1;
                        AIe <= 1;
                        next_state <= 5; // next state
                    end

                    4'b0011: begin // SUB
                        ROe <= 0;
                        BIe <= 0;

                        // ALU to A register
                        ALUOe <= 1;
                        AIe <= 1;
                        next_state <= 5; // next state
                    end

                    4'b0100: begin // OUT
                        AOe <= 0;
                        RIe <= 0;

                        // Reset for next instruction
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

            5: begin
                state <= 5;
                case (IRIo) 
                    4'b0010: begin // ADD

                        // Reset for next instruction
                        ALUOe <= 0;
                        AIe <= 0;
                        next_state <= 0; // next state
                    end

                    4'b0011: begin // SUB

                        // Reset for next instruction
                        ALUOe <= 0;
                        AIe <= 0;
                        next_state <= 0; // next state
                    end

                    4'b1111: begin // HLT
                        hlt <= 1; // halt the CPU
                    end
                    default: begin // NOP
                        state <= 0;
                    end
                endcase
            end

            default: begin
                next_state <= 0; 
            end

        endcase
    end

    initial begin
        next_state <= 0;
        ORIe <= 0;
        PCOe <= 0;
        PCIe <= 0;
        PCe <= 0;
        MARIe <= 0;
        RIe <= 0;
        ROe <= 0;
        IRIe <= 0;
        IROe <= 0;
        AOe <= 0;
        AIe <= 0;
        BOe <= 0;
        BIe <= 0;
        sub <= 0;
        ALUOe <= 0;
        hlt <= 0;
        reset <= 0;
    end


endmodule