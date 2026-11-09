import risc_pkg::*;
module alu(
    input word_t SrcA,
    input word_t SrcB,
    input ALUControl_t ALUControl,
    output word_t ALUResult,
    output logic Zero
);
    always_comb begin
        priority case(ALUControl)
            ADD: ALUResult = SrcA + SrcB;
            SUB: begin
                ALUResult = SrcA - SrcB ;
                Zero = (ALUResult == 0)? 1'b1:1'b0;
            end
            SLT: ALUResult = (SrcA<SrcB)?1'd1:'0;
            OR: ALUResult = SrcA | SrcB;
            AND: ALUResult = SrcA & SrcB;
        endcase
    end
    

endmodule
