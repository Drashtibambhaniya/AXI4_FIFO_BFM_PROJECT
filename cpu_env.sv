import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;

class cpu_env extends uvm_env;

  `uvm_component_utils(cpu_env)

  cpu_agent cpu_ag;

  function new(string name = "cpu_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cpu_ag = cpu_agent::type_id::create("cpu_ag", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass
