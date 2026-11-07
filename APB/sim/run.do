vlib work
vlog -f compile.f +cover -covercells

# FIX: Added +acc=a to visibility options and enabled -assertdebug for assertions
vsim -voptargs=+acc -assertdebug work.apb_master_tb work.apb_bind_wrapper -cover

do wave.do
run -all
#quit -sim