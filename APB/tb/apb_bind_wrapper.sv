module apb_bind_wrapper;
bind apb_master apb_assertions assertions (.pclk(pclk),.rst_n(rst_n),.transfer(transfer),.PREADY(PREADY),.PRDATA(PRDATA),.MADDR(MADDR),.MWRITE(MWRITE),.MWDATA(MWDATA),.MSTRB(MSTRB),.PSEL(PSEL),.PENABLE(PENABLE),.PADDR(PADDR),.PWRITE(PWRITE),.PWDATA(PWDATA),.PSTRB(PSTRB),.MRDATA(MRDATA));
endmodule