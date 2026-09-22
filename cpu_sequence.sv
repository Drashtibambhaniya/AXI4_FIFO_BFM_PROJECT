import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;


class cpu_sequence extends uvm_sequence #(cpu_packet);

  `uvm_object_utils(cpu_sequence)

  function new(string name = "cpu_sequence");
    super.new(name);
  endfunction

  virtual task body();
    cpu_packet req;
    req = cpu_packet::type_id::create("req");
    start_item(req);

    if (!req.randomize()) begin
      `uvm_fatal("CPU_SEQ", "Randomization failed for cpu_packet")
    end
    finish_item(req);

  endtask

endclass


class write_sequence extends cpu_sequence;
  `uvm_object_utils(cpu_write_sequence)

  function new(string name = "cpu_write_sequence");
    super.new(name);
  endfunction


  virtual task body();
    cpu_packet req;
    req = cpu_packet::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {is_write == 1;}) begin
      `uvm_fatal("CPU_WRITE_SEQ", "Randomization failed for write transaction" )
    end
    finish_item(req);

  endtask

endclass

class read_sequence extends cpu_sequence;

  `uvm_object_utils(cpu_read_sequence)

  function new(string name = "cpu_read_sequence");
    super.new(name);
  endfunction

  virtual task body();

    cpu_packet req;

    req = cpu_packet::type_id::create("req");

    start_item(req);

    if (!req.randomize() with {is_write == 0;}) begin
      `uvm_fatal("CPU_READ_SEQ", "Randomization failed for read transaction")

    end

    finish_item(req);

  endtask

endclass
