import uvm_pkg::*;
`include "uvm_macros.svh"

class cpu_agent_config extends uvm_object;

  `uvm_object_utils(cpu_agent_config)

  virtual cpu_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;


  function new(string name = "cpu_agent_config");
    super.new(name);
  endfunction

endclass
