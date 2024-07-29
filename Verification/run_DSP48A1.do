vlib work
vlog -f src_files.list -mfcu
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
.vcop Action toggleleafnames
run -all
#quit -sim