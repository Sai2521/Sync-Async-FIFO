package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;

    `uvm_component_utils(FIFO_test)

    virtual FIFO_if FIFO_test_vif;
    FIFO_env env;
    FIFO_config FIFO_config_obj_test;
    FIFO_sequence FIFO_test_seq;

    function new(string name = "FIFO_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        FIFO_config_obj_test = FIFO_config::type_id::create("FIFO_config_obj_test");
        env = FIFO_env::type_id::create("env",this);
        FIFO_test_seq = FIFO_sequence::type_id::create("FIFO_test_seq",this);

        if(!uvm_config_db #(virtual FIFO_if)::get(this,"","FIFO_IF",FIFO_config_obj_test.FIFO_config_vif))
            `uvm_fatal("build_phase","Test - Unable to get the virtual interface of the FIFO from the uvm_config_db");
        uvm_config_db #(FIFO_config)::set(this,"*","CFG",FIFO_config_obj_test);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW)
        FIFO_test_seq.start(env.agent_env.sequencer_agent);
        `uvm_info("run_phase","Stimulus Generation Ended",UVM_LOW)
        phase.drop_objection(this);
    endtask: run_phase

endclass: FIFO_test
endpackage
