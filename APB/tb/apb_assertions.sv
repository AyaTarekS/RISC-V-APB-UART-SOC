import apb_pkg::*;
module apb_assertions(
    input logic pclk,
    input logic rst_n,
    input logic transfer,
    input logic PREADY,
    input logic PRDATA,
    input logic [APB_ADDRESS-1:0] MADDR,
    input logic MWRITE,
    input word_t MWDATA,
    input logic [APB_DATA_BYTES-1:0] MSTRB,
    input logic [APB_SEL_BITS-1:0] PSEL,
    input logic PENABLE,
    input logic [APB_ADDRESS-1:0] PADDR,
    input logic PWRITE,
    input word_t PWDATA,
    input logic [APB_DATA_BYTES-1:0] PSTRB,
    input word_t MRDATA
);
    sequence start_transaction;
        transfer ##1 $onehot(PSEL);
    endsequence
    sequence succesful_transaction;
        PENABLE and PREADY and !transfer;
    endsequence
    sequence extended_transaction;
        PENABLE and PREADY and transfer;
    endsequence
    sequence no_transaction;
        (!PENABLE and !PSEL);
    endasequence


    sequence stable_write_transaction;
        $stable(PSEL) and PWRITE and $stable(PADDR) and $stable(PSTRB) and PENABLE;
    endsequence

    sequence extended_write_access_transaction;
        $stable(PSEL) and PWRITE and $stable(PADDR) and $stable(PSTRB) and !PREADY and PENABLE;
    endsequence


    sequence stable_read_transaction;
        $stable(PSEL) and !PWRITE and (PSTRB == '0) and $stable(PADDR) and PENABLE;
    endsequence

    sequence extended_read_access_transaction;
        $stable(PSEL) and !PWRITE and (PSTRB == '0) and $stable(PADDR) and PENABLE and !PREADY;
    endsequence


    //general assertions
    property p_apb_access_after_setup;
        @(posedge pclk) disable iff(!rst_n) $onehot(PSEL) |=> (PENABLE and $stable(PSEL));
    endproperty

    property p_apb_setup_after_transfer;
        @(posedge pclk) disable iff(!rst_n) transfer |=> $onehot(PSEL);
    endproperty

    property p_apb_idle_after_transaction;
        @(posedge pclk) disable iff(!rst_n) succesful_transaction |=> no_transaction;
    endproperty

    property p_apb_setup_after_extending;
        @(posedge pclk) disable iff(!rst_n) extended_transaction |=> ($onehot(PSEL) and !PENABLE);
    endproperty

    property p_apb_idle_phase;
        @(posedge pclk) disable iff(!rst_n) !transfer |=> no_transaction; 
    endproperty

    //write assertions
    property p_apb_write_transaction;
        @(posedge pclk) disable iff(!rst_n) start_transaction |=> stable_write_transaction ;
    endproperty

    property p_apb_extended_write;
        @(posedge pclk) disable iff(!rst_n) extended_write_access_transaction |=> stable_write_transaction;
    endproperty


    //read assertions
    property p_apb_read_transaction;
        @(posedge pclk) disable iff(!rst_n) start_transaction |=> stable_read_transaction and PENABLE;
    endproperty

    property p_apb_extended_read;
        @(posedge pclk) disable iff(!rst_n) extended_read_access_transaction |=> stable_read_transaction;
    endproperty


    // Assertions 
    assert property (p_apb_access_after_setup);
    assert property (p_apb_setup_after_transfer);
    assert property (p_apb_idle_after_transaction);
    assert property (p_apb_setup_after_extending);
    assert property (p_apb_idle_phase);

    assert property(p_apb_write_transaction);
    assert property(p_apb_extended_write);

    assert property(p_apb_read_transaction);
    assert property(p_apb_extended_read);

    cover property (p_apb_access_after_setup);
    cover property (p_apb_setup_after_transfer);
    cover property (p_apb_idle_after_transaction);
    cover property (p_apb_setup_after_extending);
    cover property (p_apb_idle_phase);

    cover property(p_apb_write_transaction);
    cover property(p_apb_extended_write);

    cover property(p_apb_read_transaction);
    cover property(p_apb_extended_read);   
endmodule