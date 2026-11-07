onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {system inp} /apb_master_tb/cpu/pclk
add wave -noupdate -expand -group {system inp} /apb_master_tb/cpu/rst_n
add wave -noupdate -expand -group {APB input from slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PREADY
add wave -noupdate -expand -group {APB input from slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PRDATA
add wave -noupdate -expand -group {APB input from Master} -color {Sky Blue} /apb_master_tb/cpu/MADDR
add wave -noupdate -expand -group {APB input from Master} -color {Sky Blue} /apb_master_tb/cpu/MWRITE
add wave -noupdate -expand -group {APB input from Master} -color {Sky Blue} /apb_master_tb/cpu/MWDATA
add wave -noupdate -expand -group {APB input from Master} -color {Sky Blue} -radix binary /apb_master_tb/cpu/MSTRB
add wave -noupdate -expand -group {APB input from Master} -color {Sky Blue} /apb_master_tb/cpu/transfer
add wave -noupdate -expand -group {APB output for master} -color {Sky Blue} /apb_master_tb/cpu/MRDATA
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PSEL
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PENABLE
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PADDR
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PWRITE
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} /apb_master_tb/cpu/PWDATA
add wave -noupdate -expand -group {APB output for the slave} -color {Medium Slate Blue} -radix binary /apb_master_tb/cpu/PSTRB
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} /apb_master_tb/cpu/PSEL_q
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} /apb_master_tb/cpu/PENABLE_q
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} /apb_master_tb/cpu/PADDR_q
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} /apb_master_tb/cpu/PWRITE_q
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} /apb_master_tb/cpu/PWDATA_q
add wave -noupdate -expand -group {Data Registered} -color {Sky Blue} -radix binary /apb_master_tb/cpu/PSTRB_q
add wave -noupdate -expand -group {Data Registered} /apb_master_tb/cpu/state_q
add wave -noupdate -expand -group {Data Registered} -color {Medium Slate Blue} /apb_master_tb/cpu/MRDATA_q
add wave -noupdate -expand -group {Data next logic} /apb_master_tb/cpu/state_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} /apb_master_tb/cpu/PENABLE_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} /apb_master_tb/cpu/PSEL_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} /apb_master_tb/cpu/PADDR_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} /apb_master_tb/cpu/PWRITE_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} /apb_master_tb/cpu/PWDATA_next
add wave -noupdate -expand -group {Data next logic} -color {Sky Blue} -radix binary /apb_master_tb/cpu/PSTRB_next
add wave -noupdate -expand -group {Data next logic} -color {Medium Slate Blue} /apb_master_tb/cpu/MRDATA_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 241
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {925 ns}
