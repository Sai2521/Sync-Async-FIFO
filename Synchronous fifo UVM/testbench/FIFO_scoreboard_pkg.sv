package FIFO_scoreboard_pkg;
import FIFO_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(FIFO_scoreboard);
    uvm_analysis_export #(MySequenceItem) sb_export;
    uvm_tlm_analysis_fifo #(MySequenceItem) sb_fifo;

    //Signals declaration
    MySequenceItem item_scoreboard;
    logic [15:0] data_out_ref;
    logic wr_ack_ref, overflow_ref,underflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref;
    int Error_count=0, Correct_count=0, count=0;

    //FIFO queue
    logic [15:0] FIFO_queue [$];  

    function new(string name ="FIFO_scoreboard",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(item_scoreboard);
            ref_model(item_scoreboard);
            if((item_scoreboard.data_out!=data_out_ref) || (item_scoreboard.wr_ack!=wr_ack_ref) || (item_scoreboard.overflow!=overflow_ref) || 
            (item_scoreboard.underflow!=underflow_ref) || (item_scoreboard.full!=full_ref) || (item_scoreboard.empty!=empty_ref) || 
            (item_scoreboard.almostfull!=almostfull_ref) || (item_scoreboard.almostempty!= almostempty_ref)) begin
                Error_count++;
                `uvm_error("run_phase", 
                $sformatf("Comparison failed, Transaction received by DUT: %s while reference outputs: data_out_ref=0b%0b, wr_ack_ref=0b%0b,
                overflow_ref=0b%0b, underflow_ref=0b%0b, full_ref=0b%0b, empty_ref=0b%0b, almostfull_ref=0b%0b, almostempty_ref=0b%0b", 
                item_scoreboard.convert2string(), data_out_ref, wr_ack_ref, overflow_ref, underflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref)
);
            end
            else 
                Correct_count++;
        end
    endtask

    task ref_model(MySequenceItem item_check);
        /////////////////////////////////Reset Signal///////////////////////////////
        if(!item_check.rst_n) begin
            FIFO_queue.delete();
            count=0; wr_ack_ref=0; overflow_ref=0; underflow_ref=0; full_ref=0; empty_ref=1; almostfull_ref=0; almostempty_ref=0; 
        end
        else begin

        ////////////////////////////////Reading and Writing/////////////////////////////// 
            //write only
            if(item_check.rd_en && item_check.wr_en && count==0) begin
                underflow_ref=1;                                                              
                FIFO_queue.push_front(item_check.data_in);
                wr_ack_ref=1;
                overflow_ref=0;    
                almostempty_ref=1;
                almostfull_ref=0;
                empty_ref=0;
                full_ref=0;

            count++;
            end
            //Read only
            else if(item_check.rd_en && item_check.wr_en && count==8) begin                                 
                overflow_ref=1;
                data_out_ref=FIFO_queue.pop_back();
                wr_ack_ref=0;
                underflow_ref=0;
                almostempty_ref=0;
                almostfull_ref=1;
                empty_ref=0;
                full_ref=0;
        
            count--;
            end
            //Write and Read Together
            else begin    
                if(item_check.wr_en && count < 8) begin
                    FIFO_queue.push_front(item_check.data_in);
                    count++;
                end
                if(item_check.rd_en && (count != 0)) begin
                    data_out_ref=FIFO_queue.pop_back();
                    count--;
                end

            //All Control signals
            ///////////////////////////////Over and Under flow Signals///////////////////////////////
            //Overflow signal
            if(item_check.wr_en && full_ref)  overflow_ref=1;
            else    overflow_ref=0;
            //Underflow signal
            if(item_check.rd_en && empty_ref)  underflow_ref=1;
            else    underflow_ref=0;
            /////////////////////////////////Write acknowledge Signal///////////////////////////////
            if((item_check.rd_en && item_check.wr_en && empty_ref)||(item_check.wr_en && count <= 8 && overflow_ref==0)) wr_ack_ref=1;
            else wr_ack_ref=0;
            ///////////////////////////////full and empty  Signals///////////////////////////////
            //Full signal
            if(count == 8)  full_ref=1;
            else    full_ref =0;
            //Empty signal
            if(count == 0)  empty_ref=1;
            else    empty_ref=0;
            ///////////////////////////////Almost empty and full Signals///////////////////////////////
            //Almost empty signal
            if(count == 1)    almostempty_ref=1;
            else    almostempty_ref=0;
            //Almost full signal
            if(count==(7)) almostfull_ref=1;
            else    almostfull_ref=0;

            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",Correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",Error_count),UVM_MEDIUM);
    endfunction
endclass
endpackage