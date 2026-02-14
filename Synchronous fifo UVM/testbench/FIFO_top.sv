import FIFO_test_pkg::*;
import FIFO_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module FIFO_top();
logic clk;
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
FIFO_if FIFOif(clk);
FIFO FIFO_DUT(FIFOif);
bind FIFO FIFO_assertions FIFO_assertions_inst(FIFOif);

initial begin
    uvm_config_db#(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_IF",FIFOif);
    run_test("FIFO_test");
end

endmodule
