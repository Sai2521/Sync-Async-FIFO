package FIFO_agent_pkg;
import FIFO_sequenceitem_pkg::*;
import FIFO_sequencer_pkg::*;
import FIFO_driver_pkg::*;
import FIFO_monitor_pkg::*;
import FIFO_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_agent extends uvm_agent;
`uvm_component_utils(FIFO_agent);

FIFO_config config_agent;
FIFO_sequencer sequencer_agent;
FIFO_driver driver_agent;
FIFO_monitor monitor_agent;

uvm_analysis_port #(MySequenceItem) agent_ap;

function new(string name = "FIFO_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(FIFO_config)::get(this,"","CFG",config_agent))
        `uvm_fatal("build_phase","Unable to get configruation object");

    sequencer_agent=FIFO_sequencer::type_id::create("sequencer_agent",this);
    driver_agent=FIFO_driver::type_id::create("driver_agent",this);
    monitor_agent=FIFO_monitor::type_id::create("monitor_agent",this);
    agent_ap= new("agent_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
    driver_agent.FIFO_driver_vif =  config_agent.FIFO_config_vif;
    monitor_agent.FIFO_monitor_vif = config_agent.FIFO_config_vif;
    driver_agent.seq_item_port.connect(sequencer_agent.seq_item_export);
    monitor_agent.monitor_ap.connect(agent_ap);
endfunction
endclass   
endpackage
