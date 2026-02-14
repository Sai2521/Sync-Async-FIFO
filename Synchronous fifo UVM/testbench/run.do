vlib work
vlog -f src_files.list.txt +cover -covercells
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
add wave /FIFO_top/FIFOif/*
add wave -position insertpoint  \
sim:/FIFO_top/FIFO_DUT/mem \
sim:/FIFO_top/FIFO_DUT/wr_ptr \
sim:/FIFO_top/FIFO_DUT/rd_ptr \
sim:/FIFO_top/FIFO_DUT/count
run -all
coverage save FIFO_top.ucdb -onexit 
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_wr_ack/<auto[0],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_wr_ack/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_overflow/<auto[0],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_overflow/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_underflow/<auto[1],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_underflow/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_full/<auto[1],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/cov_gp/wr_rd_full/<auto[0],auto[1],auto[1]>}

