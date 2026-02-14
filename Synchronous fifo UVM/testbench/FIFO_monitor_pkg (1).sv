package FIFO_monitor_pkg;

import FIFO_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_monitor extends uvm_monitor;

    `uvm_component_utils(FIFO_monitor);
    virtual FIFO_if FIFO_monitor_vif;
    MySequenceItem item_monitor;
    uvm_analysis_port #(MySequenceItem) monitor_ap;



    function new(string name = "FIFO_monitor", uvm_component parent = null);
        super.new(name , parent);    
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_ap = new("monitor_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item_monitor = MySequenceItem::type_id::create("item_monitor");
            @(negedge FIFO_monitor_vif.clk);
            item_monitor.rst_n=FIFO_monitor_vif.rst_n; 
            item_monitor.wr_en=FIFO_monitor_vif.wr_en;
            item_monitor.rd_en=FIFO_monitor_vif.rd_en;
            item_monitor.data_in=FIFO_monitor_vif.data_in;
            item_monitor.data_out=FIFO_monitor_vif.data_out;
            item_monitor.wr_ack=FIFO_monitor_vif.wr_ack;
            item_monitor.overflow=FIFO_monitor_vif.overflow;
            item_monitor.underflow=FIFO_monitor_vif.underflow;
            item_monitor.full=FIFO_monitor_vif.full;
            item_monitor.empty=FIFO_monitor_vif.empty;
            item_monitor.almostfull=FIFO_monitor_vif.almostfull;
            item_monitor.almostempty=FIFO_monitor_vif.almostempty;

            monitor_ap.write(item_monitor);
            `uvm_info("run_phase",item_monitor.convert2string(),UVM_HIGH)
        end
    endtask
endclass //FIFO_monitor extends superClass   
endpackage
