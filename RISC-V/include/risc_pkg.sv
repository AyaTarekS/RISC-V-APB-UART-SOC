package risc_pkg;
    
    parameter int WORD_WIDTH = 32;
    parameter int EXTEND_INPUT_WIDTH = 24;
    parameter int IMM_SRC_WIDTH = 2;
    parameter int ALU_CONTROL_WIDTH = 3;
    parameter int LOWEST_ADDRESS = 32'h0000_1000;
    parameter int REGISTERS_NUM = 32;
    parameter int REGISTERS_ADDR_WIDTH = $clog2(REGISTERS_NUM);
    parameter int FUNC3_WIDTH = 3;
    parameter int ALU_OP_WIDTH = 2;
    parameter int OP_WIDTH = 7;
    parameter int RESULT_SRC_WIDTH = 2;
    
    
    //INSTRUCTION SET DECODING
    typedef enum [OP_WIDTH-1:0]{
        I_TYPE = 7'b0000_011,
        S_TYPE = 7'b0100_011,
        R_TYPE = 7'b0110_011,
        B_TYPE = 7'b1100_011,
        I_ALU  = 7'b0010_011,
        J_TYPE = 7'b1101_111
    } OP_t;
    
    //ALU CONTROL
    typedef enum [ALU_CONTROL_WIDTH-1:0] { 
        ADD = 3'b000,
        SUB = 3'b001,
        SLT = 3'b101,
        OR  = 3'b011,
        AND = 3'b010 } ALUControl_t;
    
    
    typedef logic [WORD_WIDTH-1:0] word_t; 
    typedef logic [REGISTERS_ADDR_WIDTH-1:0] reg_add_t;

    // struct made for the signals will be transformed
typedef struct packed {
    word_t InstrF ;
    word_t PCF;
    word_t PCPlus4F;
} fetch_signals_t;

typedef struct packed {
    logic RegWriteD;
    logic [RESULT_SRC_WIDTH-1:0] ResultSrcD;
    logic MemWriteD, JumpD, BranchD;
    ALUControl_t ALUControlD;
    logic ALUSrcD;
    word_t PCD , PCPlus4D;
    word_t ImmExtD;
    reg_add_t RdD;
    word_t RD1D,
    word_t RD2D
} decoding_signals_t;

typedef struct packed {
    logic RegWriteE;
    logic [RESULT_SRC_WIDTH-1:0] ResultSrcE;
    logic MemWriteE, JumpE, BranchE;
    ALUControl_t ALUControlE;
    logic ALUSrcE;
    word_t PCE , PCPlus4E;
    word_t ImmExtE;
    reg_add_t RdE;
    word_t RD1E;
    word_t RD2E;
    logic PCSrcE;
    word_t WriteDataE, ALUResultE;
} excuting_signals_t;

typedef struct packed {
    logic RegWriteM;
    logic [RESULT_SRC_WIDTH-1:0] ResultSrcM;
    word_t ALUResultM, ReadDataM, PCPlus4M;
} memory_signals_t;


endpackage