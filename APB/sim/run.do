vlib work
vlog -f compile.f  +cover -covercells
vsim -voptargs=+acc work.apb_master_tb -cover 
#add wave -position insertpoint /uart_tb/uart_inst/*
run -all
#quit -sim