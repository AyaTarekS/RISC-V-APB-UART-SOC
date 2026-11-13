import risc_pkg::*;
module control_unit(
    input logic Zero,
    input OP_t op,
    input logic [FUNC3_WIDTH-1:0] funct3,
    input logic funct7,
    output logic Branch,
    output logic Jump,
    output logic ResultSrc,
    output logic MemWrite,
    output logic ALUSrc,
    output logic [IMM_SRC_WIDTH-1:0] ImmSrc,
    output logic RegWrite,
    output ALUControl_t ALUControl
);
    // SIGNALS
    logic [ALU_OP_WIDTH-1:0] ALUOp;

    // MAIN DECODER INSTANCE
    main_decoder main_decoder_instance (
        .op(op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .Jump(Jump)
    );
    // ALU DECODER INSTANCE
    alu_decoder alu_decoder_instance (
        .op5(op[5]),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );
endmodule