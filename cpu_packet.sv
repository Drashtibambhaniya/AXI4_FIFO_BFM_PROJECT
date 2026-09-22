import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;


class cpu_packet extends uvm_sequence_item;

  rand bit is_write;
  rand bit [TXN_ID_WIDTH-1:0] txn_id;
  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [LEN_WIDTH-1:0] len;
  rand bit [SIZE_WIDTH-1:0] size;
  rand bit [BURST_WIDTH-1:0] burst;
  rand bit [LOCK_WIDTH-1:0] lock;
  rand bit [CACHE_WIDTH-1:0] cache;
  rand bit [PROT_WIDTH-1:0] prot;
  rand bit [STRB_WIDTH-1:0] strobe;
  rand bit [MAX_DATA_WIDTH-1:0] data;

  `uvm_object_utils_begin(cpu_packet)

    `uvm_field_int(is_write, UVM_ALL_ON)
    `uvm_field_int(txn_id, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(len, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_field_int(lock, UVM_ALL_ON)
    `uvm_field_int(cache, UVM_ALL_ON)
    `uvm_field_int(prot, UVM_ALL_ON)
    `uvm_field_int(strobe, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name = "cpu_packet");
    super.new(name);
  endfunction

endclass
