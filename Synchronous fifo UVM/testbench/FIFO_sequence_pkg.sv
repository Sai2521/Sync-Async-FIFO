package FIFO_sequence_pkg;
import FIFO_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_sequence extends uvm_sequence #(MySequenceItem);

`uvm_object_utils(FIFO_sequence);
MySequenceItem item;

//Constructor for the sequence
function new(string name = "MySequence");
    super.new(name);    
endfunction

//Main task for the sequence
virtual task body();
    //Reset initialization
    item = MySequenceItem::type_id::create("item"); //Create a sequence item
    start_item(item);
    item.rst_n=0; item.data_in=0; item.wr_en=0; item.rd_en=0;
    finish_item(item);
    

    repeat(10000) begin
        item = MySequenceItem::type_id::create("item"); //Create a sequence item
        start_item(item);
        assert (item.randomize());
        finish_item(item);
    end
endtask
endclass    
endpackage
