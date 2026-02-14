package FIFO_env_pkg;
import FIFO_agent_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_env extends uvm_env;
`uvm_component_utils(FIFO_env)

FIFO_agent agent_env;
FIFO_coverage coverage_env;
FIFO_scoreboard scoreboard_env;

function new(string name= "FIFO_env",uvm_component parent =null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_env = FIFO_agent::type_id::create("agent_env",this);
    coverage_env = FIFO_coverage::type_id::create("coverage_env",this);
    scoreboard_env = FIFO_scoreboard::type_id::create("scoreboard_env",this);
    
endfunction: build_phase

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent_env.agent_ap.connect(coverage_env.cov_export);
    agent_env.agent_ap.connect(scoreboard_env.sb_export);
endfunction

endclass
endpackage
