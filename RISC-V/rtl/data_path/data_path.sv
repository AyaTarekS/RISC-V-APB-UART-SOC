import risc_pkg::*;

module data_path (
    input  logic CLK,
    input  logic rst_n,

    // INPUT <- CONTROL UNIT
    input  logic RegWrite,
    input  logic [RESULT_SRC_WIDTH-1:0] ResultSrc,
    input  logic MemWrite,
    input  logic Jump,
    input  logic Branch,
    input  ALUControl_t ALUControl,
    input  logic ALUSrc,
    input  logic [IMM_SRC_WIDTH-1:0] ImmSrc,

    // INPUT <- HAZARDS UNIT
    input  logic StallF,
    input  logic StallD,
    input  logic FlushD,
    input  logic FlushE,
    input  logic [1:0] ForwardAE,
    input  logic [1:0] ForwardBE,

    // OUTPUT -> CONTROL UNIT
    output OP_t op,
    output logic [FUNC3_WIDTH-1:0] funct3,
    output logic funct7,

    // OUTPUT -> HAZARD UNIT
    output reg_add_t Rs1D,
    output reg_add_t Rs2D,
    output reg_add_t Rs1E,
    output reg_add_t Rs2E,
    output reg_add_t RdE,
    output reg_add_t RdM,
    output logic ResultSrcE0,
    output reg_add_t RdW,
    output logic RegWriteW
);

    // ============================================================
    // FETCH PHASE SIGNALS
    // ============================================================
    word_t PCFNext;
    fetch_signals_t fetch_phase;

    // ============================================================
    // DECODE PHASE SIGNALS
    // ============================================================
    word_t InstrD;
    logic [IMM_SRC_WIDTH-1:0] ImmSrcD;
    decoding_signals_t decoding_phase;

    // ============================================================
    // EXECUTE PHASE SIGNALS
    // ============================================================
    word_t SrcAE, SrcBE;
    word_t PCTargetE;
    logic ZeroE;
    excuting_signals_t executing_phase;

    // ============================================================
    // MEMORY PHASE SIGNALS
    // ============================================================
    logic MemWriteM;
    word_t WriteDataM;
    memory_signals_t memory_phase;

    // ============================================================
    // WRITEBACK PHASE SIGNALS
    // ============================================================
    word_t ALUResultW;
    word_t ReadDataW;
    word_t PCPlus4W;
    word_t ResultW;

    logic [RESULT_SRC_WIDTH-1:0] ResultSrcW;

    // ============================================================
    // FETCH PHASE
    // ============================================================

    assign PCFNext =
        (PCSrcE == 1'b1) ?
        PCTargetE :
        fetch_phase.PCPlus4F;

    program_counter pc (
        .CLK    (CLK),
        .rst_n  (rst_n),
        .EN     (~StallF),
        .PCNext (PCFNext),
        .PC     (fetch_phase.PCF)
    );

    adder pc_4 (
        .a   (fetch_phase.PCF),
        .b   (32'd4),
        .sum (fetch_phase.PCPlus4F)
    );

    instruction_mem instr_mem (
        .A  (fetch_phase.PCF),
        .RD (fetch_phase.InstrF)
    );

    always_ff @(posedge CLK or posedge FlushD) begin
        if (FlushD) begin
            // TODO: Fix after reading the hazards part
        end
        else begin
            InstrD                  <= fetch_phase.InstrF;
            decoding_phase.PCD      <= fetch_phase.PCF;
            decoding_phase.PCPlus4D <= fetch_phase.PCPlus4F;
        end
    end

    // ============================================================
    // DECODING PHASE
    // ============================================================

    assign op     = InstrD[OP_WIDTH-1:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    

    register_file reg_file (
        .CLK(CLK),
        .A1 (InstrD[19:15]),
        .A2 (InstrD[24:20]),
        .A3 (RdW),
        .WD3(ResultW),
        .WE3(RegWriteW),
        .RD1(decoding_phase.RD1D),
        .RD2(decoding_phase.RD2D)
    );

    extension extend (
        .Instr (InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(decoding_phase.ImmExtD)
    );


    assign decoding_phase.RdD  = InstrD[11:7]; 

    always_ff @(posedge clk or posedge FlushE)begin
        if(FlushE)begin
            //TODO: to clear according to the hazards uint
        end
        else begin
            executing_phase.RegWriteE   <= decoding_phase.RegWriteD;
            executing_phase.ResultSrcE  <= decoding_phase.ResultSrcD;
            executing_phase.MemWriteE   <= decoding_phase.MemWriteD;
            executing_phase.JumpE       <= decoding_phase.JumpD;
            executing_phase.BranchE     <= decoding_phase.BranchD;
            executing_phase.ALUControlE <= decoding_phase.ALUControlD;
            executing_phase.ALUSrcE     <= decoding_phase.ALUSrcD;
            executing_phase.RD1E        <= decoding_phase.RD1D;
            executing_phase.RD2E        <= decoding_phase.RD2D;
            executing_phase.PCE         <= decoding_phase.PCD;
            executing_phase.RdE         <= decoding_phase.RdD;
            executing_phase.ImmExtE     <= decoding_phase.ImmExtD;
            executing_phase.PCPlus4E    <= decoding_phase.PCPlus4D;
            Rs1E                        <= Rs1D;
            Rs2E                        <= Rs2D;
            RdE                         <= decoding_phase.RdD;
        end
    end

    // ============================================================
    // EXECUTING PHASE
    // ============================================================

    // TODO: check what the pcsrc do with the hazards
    assign PCSrcE      = ((executing_phase.BranchE && ZeroE) || executing_phase.JumpE); 
    assign SrcBE       = (executing_phase.ALUSrcE == 0)? executing_phase.WriteDataE : executing_phase.ImmExtE; // TODO: check the reading and writing at the same time
    assign ResultSrcE0 = executing_phase.ResultSrcE[0];

    mux srcA_mux (
        .mux_inp_0(executing_phase.RD1E),
        .mux_inp_1(ResultW),
        .mux_inp_2(memory_phase.ALUResultM),
        .sel      (ForwardAE),
        .mux_out  (SrcAE)
    );

    mux srcB_mux (
        .mux_inp_0(executing_phase.RD2E),
        .mux_inp_1(ResultW),
        .mux_inp_2(memory_phase.ALUResultM),
        .sel      (ForwardAE),
        .mux_out  (executing_phase.WriteDataE)
    );

    alu ALU (
        .SrcA      (SrcAE),
        .SrcB      (SrcBE),
        .ALUControl(executing_phase.ALUControlE),
        .ALUResult (executing_phase.ALUResultE),
        .Zero      (ZeroE)
    );

    adder pc_targert(
        .a  (executing_phase.PCE),
        .b  (executing_phase.ImmExtE),
        .sum(PCTargetE)
    );

    always_ff @(posedge CLK or negedge rst_n)begin
        if(!rst_n)begin
            //TODO: check with the hazards
        end
        else begin
            memory_phase.RegWriteM  <= executing_phase.RegWriteE;
            memory_phase.ResultSrcM <= executing_phase.ResultSrcE;
            memory_phase.ALUResultM <= executing_phase.ALUResultE;
            memory_phase.PCPlus4M   <= executing_phase.PCPlus4E;
            MemWriteM               <= executing_phase.MemWriteE;
            WriteDataM              <= executing_phase.WriteDataE;
            RdM                     <= RdE;
        end
    end

    // ============================================================
    // MEMORY PHASE
    // ============================================================

    data_memory data_mem(
        .CLK(CLK),
        .A(memory_phase.ALUResultM),
        .WD(WriteDataM),
        .WE(MemWriteM),
        .RD(memory_phase.ReadDataM)
    );

    always_ff @(posedge CLK or negedge rst_n)begin
        if(!rst_n)begin
            //TODO: fix it withe h hazards
        end
        else begin
            RegWriteW  <= memory_phase.RegWriteM;
            ResultSrcW <= memory_phase.ResultSrcM;
            ALUResultW <= memory_phase.ALUResultM;
            ReadDataW  <= memory_phase.ReadDataM;
            PCPlus4W   <= memory_phase.PCPlus4M;
            RdW        <= RdM;
        end
    end 

    // ============================================================
    // WRITE-BACK PHASE
    // ============================================================

    mux reg_write_mux(
        .mux_inp_0(ALUResultW),
        .mux_inp_1(ReadDataW),
        .mux_inp_2(PCPlus4W),
        .sel      (ResultSrcW),
        .mux_out  (ResultW)
    );



endmodule