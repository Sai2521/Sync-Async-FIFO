package FIFO_driver_pkg;
import FIFO_config_pkg::*;
import FIFO_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_driver extends uvm_driver #(MySequenceItem);

    `uvm_component_utils(FIFO_driver)

    virtual FIFO_if FIFO_driver_vif;
    FIFO_config FIFO_config_obj_driver;
    MySequenceItem item_driver;

    function new(string name ="FIFO_driver", uvm_component parent= null);
        super.new(name,parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    
        forever begin
            item_driver = MySequenceItem::type_id::create("item_driver");
            seq_item_port.get_next_item(item_driver);

            FIFO_driver_vif.rst_n=item_driver.rst_n; 
            FIFO_driver_vif.wr_en=item_driver.wr_en;
            FIFO_driver_vif.rd_en=item_driver.rd_en;
            FIFO_driver_vif.data_in=item_driver.data_in;

            @(negedge FIFO_driver_vif.clk);   
            seq_item_port.item_done();
            `uvm_info("run_phase",item_driver.convert2string_stimulus(),UVM_HIGH); 
    end
    endtask
endclass
endpackage
