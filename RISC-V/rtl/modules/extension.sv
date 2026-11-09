import risc_pkg::*;
module extension(
    input word_t Instr,
    input logic [IMM_SRC_WIDTH-1:0] ImmSrc,
    output word_t ExtImm
);
    always_comb begin
        case (ImmSrc)
            2'b00 : ExtImm = {{20{Instr[31]}},Instr[31:20]};
            2'b01 : ExtImm = {{20{Instr[31]}},Instr[31:25],Instr[11:7]};
            2'b10 : ExtImm = {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
            2'b11 : ExtImm = {{12{Instr[31]}},Instr[19:12],Instr[19:12],Instr[20],Instr[30:21],1'b0};
            default: ExtImm = '0;
        endcase
        
    end
endmodule