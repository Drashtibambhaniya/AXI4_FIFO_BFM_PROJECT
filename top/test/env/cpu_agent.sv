import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;


class cpu_agent extends uvm_agent;

  `uvm_component_utils(cpu_agent)

  cpu_sequencer sequencer;
  cpu_driver    driver;

  cpu_agent_config cfg;


  function new(string name = "cpu_agent",uvm_component parent = null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(cpu_agent_config)::get(this,"", "cfg", cfg)) begin
      `uvm_fatal( "CPU_AGENT", "Failed to get cpu_agent_config")
    end

    if (cfg.is_active == UVM_ACTIVE) begin
      sequencer = cpu_sequencer::type_id::create("sequencer", this);
      driver = cpu_driver::type_id::create("driver", this);

      uvm_config_db#(cpu_agent_config)::set(this,"driver", "cfg",cfg);

    end
  endfunction


  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.is_active == UVM_ACTIVE) begin

      driver.seq_item_port.connect(sequencer.seq_item_export);

    end
  endfunction


endclass
