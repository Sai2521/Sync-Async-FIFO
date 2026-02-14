package FIFO_sequenceitem_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class MySequenceItem extends uvm_sequence_item;
`uvm_object_utils(MySequenceItem)

//Signals Declarations

rand logic rst_n, wr_en, rd_en;
rand logic [15:0] data_in;

logic [15:0] data_out;
logic clk,wr_ack, overflow,full, empty, almostfull, almostempty, underflow;



//Constructor for the sequence item
function new(string name = "MySequenceItem");
    super.new(name);

endfunction

function string convert2string();
    return $sformatf("rst_n=0b%0b,wr_en=0b%0b,rd_en=0b%0b,data_in=0b%0b,data_out=0b%0b,wr_ack=0b%0b,overflow=0b%0b,\
    underflow=0b%0b,full=0b%0b,empty=0b%0b,almostfull=0b%0b,almostempty=0b%0b", 
    rst_n, wr_en, rd_en, data_in, data_out, wr_ack,
    overflow, underflow, full, empty, almostfull, almostempty);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst_n=0b%0b,wr_en=0b%0b,rd_en=0b%0b,data_in=0b%0b", 
    rst_n, wr_en, rd_en, data_in);
endfunction

//Constraint blocks
constraint reset{rst_n dist {0:=5,1:=95};}
constraint write_enable{wr_en dist{0:=(30),1:=70};}
constraint read_enable{rd_en dist{0:=(70),1:=30};}

endclass    
endpackage
