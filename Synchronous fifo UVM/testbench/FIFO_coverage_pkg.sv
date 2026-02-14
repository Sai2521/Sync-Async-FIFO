package FIFO_coverage_pkg;
import FIFO_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_coverage extends uvm_component;
`uvm_component_utils(FIFO_coverage);

uvm_analysis_export #(MySequenceItem) cov_export;
uvm_tlm_analysis_fifo #(MySequenceItem) cov_fifo;
MySequenceItem item_cov;

//Covergroups
covergroup cov_gp ;
    
    data_out_cp: coverpoint item_cov.data_out {
        bins data_out_bin = {[0:$]};
        option.weight=0;
        }

    wr_rd_data_out: cross item_cov.wr_en,item_cov.rd_en,data_out_cp;
    wr_rd_wr_ack: cross item_cov.wr_en,item_cov.rd_en,item_cov.wr_ack;
    wr_rd_overflow: cross item_cov.wr_en,item_cov.rd_en,item_cov.overflow;
    wr_rd_underflow: cross item_cov.wr_en,item_cov.rd_en,item_cov.underflow;
    wr_rd_full: cross item_cov.wr_en,item_cov.rd_en,item_cov.full;
    wr_rd_empty: cross item_cov.wr_en,item_cov.rd_en,item_cov.empty;
    wr_rd_almostfull: cross item_cov.wr_en,item_cov.rd_en,item_cov.almostfull;
    wr_rd_almostempty: cross item_cov.wr_en,item_cov.rd_en,item_cov.almostempty;
    //option.auto_bin_max=0;

endgroup

//Defining the new function and the covergroup inside it
function new(string name = "FIFO_coverage", uvm_component parent = null);
    super.new(name,parent);
    cov_gp=new();        
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(item_cov);
        cov_gp.sample();
    end
endtask
endclass
endpackage
