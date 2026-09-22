import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;

class cpu_sequencer extends uvm_sequencer #(cpu_packet);
  `uvm_component_utils(cpu_sequencer)

  function new(string name = "cpu_sequencer",uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
