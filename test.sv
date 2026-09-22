import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;
class base_test extends uvm_test;

  `uvm_component_utils(cpu_base_test)

  cpu_env cpu_env_h;
  cpu_agent_config cpu_cfg;
  
  function new(string name = "cpu_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cpu_env_h = cpu_env::type_id::create("cpu_env_h", this); 
    cpu_cfg = cpu_agent_config::type_id::create("cpu_cfg");

    if (!uvm_config_db#(virtual cpu_if)::get(this, "", "vif", cpu_cfg.vif)) begin
      `uvm_fatal("CPU_BASE_TEST", "Failed to get virtual cpu_if")
    end

    cpu_cfg.is_active = UVM_ACTIVE;
    uvm_config_db#(cpu_agent_config)::set(this,"cpu_env_h.cpu_ag", "cfg",cpu_cfg);

  endfunction
 

  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("CPU_BASE_TEST","END_OF_ELABORATION_PHASE",UVM_NONE)

    uvm_top.print_topology();
  endfunction
endclass


class cpu_write_test extends cpu_base_test;

  `uvm_component_utils(cpu_write_test)

  function new(string name = "cpu_write_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction


 
  task run_phase(uvm_phase phase);

    cpu_write_sequence seq;
    phase.raise_objection(this);

    `uvm_info("CPU_WRITE_TEST","Starting CPU write sequence",UVM_LOW)
    seq = cpu_write_sequence::type_id::create("seq");


    seq.start(cpu_env_h.cpu_ag.sequencer);
    phase.drop_objection(this);

  endtask

endclass



class cpu_read_test extends cpu_base_test;

  `uvm_component_utils(cpu_read_test)
 
  function new(string name = "cpu_read_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);

    cpu_read_sequence seq;
    phase.raise_objection(this);

    `uvm_info("CPU_READ_TEST", "Starting CPU read sequence", UVM_LOW)
    seq = cpu_read_sequence::type_id::create("seq");


    seq.start(cpu_env_h.cpu_ag.sequencer);
    phase.drop_objection(this);

  endtask

endclass
