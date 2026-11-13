import risc_pkg::*;
module alu_decoder(
    input logic op5,
    input [ALU_OP_WIDTH-1:0] ALUOp,
    input [FUNC3_WIDTH-1:0] funct3,
    input logic funct7,
    output ALUControl_t ALUControl
);
    always_comb begin
        priority case(ALUOp)
            2'b00: ALUControl = ADD;
            2'b01: ALUControl = SUB;
            2'b10: begin
                priority case(funct3)
                    3'b000: begin
                        if({op5,funct7}==2'b11)
                            ALUControl = SUB;
                        else 
                            ALUControl = ADD;
                    end
                    3'b010: ALUControl = SLT;
                    3'b110: ALUControl = OR;
                    3'b111: ALUControl = AND;
                endcase
            end
        endcase      
    end
    
endmodule
