import risc_pkg::*;
module main_decoder(
    input OP_t op,
    output logic RegWrite,
    output logic [IMM_SRC_WIDTH-1:0] ImmSrc,
    output logic ALUSrc,
    output logic MemWrite,
    output logic [RESULT_SRC_WIDTH-1:0] ResultSrc,
    output logic Branch,
    output logic [ALU_OP_WIDTH-1:0] ALUOp,
    output logic Jump
);
    always_comb begin
       priority case(op)
            I_TYPE: begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b01;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            S_TYPE: begin
                RegWrite = 1'b0;
                ImmSrc = 2'b01;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
                ResultSrc = 2'b00; //don't care
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
            R_TYPE: begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;    //don't care
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            B_TYPE: begin
                RegWrite = 1'b0;
                ImmSrc = 2'b10;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00; // don't care
                Branch = 1'b1;
                ALUOp = 2'b01;
                Jump = 1'b0;
            end
            I_ALU: begin
                RegWrite = 1'b1;
                ImmSrc = 2'b00;
                ALUSrc = 1'b1;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b10;
                Jump = 1'b0;
            end
            J_TYPE: begin
                RegWrite = 1'b1;
                ImmSrc = 2'b11;
                ALUSrc = 1'b0; // don't care
                MemWrite = 1'b0;
                ResultSrc = 2'b10;
                Branch = 1'b0;
                ALUOp = 2'b00; // don't care
                Jump = 1'b1;
            end
            default: begin
                RegWrite = 1'b0;
                ImmSrc = 2'b00;
                ALUSrc = 1'b0;
                MemWrite = 1'b0;
                ResultSrc = 2'b00;
                Branch = 1'b0;
                ALUOp = 2'b00;
                Jump = 1'b0;
            end
        endcase
    end
endmodule