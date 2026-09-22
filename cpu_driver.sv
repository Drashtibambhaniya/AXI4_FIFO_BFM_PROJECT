import uvm_pkg::*;
`include "uvm_macros.svh"

import defines::*;


class cpu_driver extends uvm_driver #(cpu_packet);

  `uvm_component_utils(cpu_driver)
  cpu_agent_config cfg;

  virtual cpu_if vif;


  function new(string name = "cpu_driver",uvm_component parent = null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(cpu_agent_config)::get(this,"", "cfg", cfg)) begin
      `uvm_fatal("CPU_DRV", "Failed to get cpu_agent_config")
    end

    vif = cfg.vif;

    if (vif == null) begin
      `uvm_fatal("CPU_DRV", "CPU virtual interface is null")
    end
  endfunction


  
  task run_phase(uvm_phase phase);

    cpu_packet req;

    vif.drv_cb.wr_en   <= 1'b0;
    vif.drv_cb.wr_data <= '0;
    vif.drv_cb.rd_en   <= 1'b0;

    forever begin
      seq_item_port.get_next_item(req);

      `uvm_info("CPU_DRV", $sformatf("Received CPU transaction:\n%s", req.sprint()), UVM_MEDIUM)

      drive_packet(req);
      seq_item_port.item_done();

    end

  endtask


  //============================================================
  // Drive Packet
  //============================================================
  virtual task drive_packet(cpu_packet req);

    bit packet_bits[$];
    bit [FIFO_DATA_WIDTH-1:0] data_words[$];


    // Build complete packet
    build_packet_bits(
      req,
      packet_bits
    );


    // Convert packet into 128-bit data words
    group_bits_into_data(
      packet_bits,
      data_words
    );


    `uvm_info(
      "CPU_DRV",
      $sformatf(
        "Packet generated: %0d bits -> %0d data words",
        packet_bits.size(),
        data_words.size()
      ),
      UVM_MEDIUM
    );


    // Drive data words onto CPU interface
    drive_data(data_words);

  endtask


  
  virtual function bit [63:0] build_header(
    cpu_packet req
  );

    bit [63:0] header;

    header = {
      SOP,
      req.txn_id,
      req.addr,
      req.len,
      req.size,
      req.burst,
      req.lock,
      req.cache,
      req.prot,
      req.strobe
    };

    return header;

  endfunction


  virtual function void build_packet_bits(
    input cpu_packet req,
    ref bit packet_bits[$]
  );

    bit [63:0] header;
    int payload_bits;


    packet_bits.delete();


    // Build header
    header = build_header(req);


    // Calculate payload size
    payload_bits = (1 << req.size) * req.len;


    // Add header
    for (int i = 63; i >= 0; i--) begin

      packet_bits.push_back(header[i]);

    end

    if (req.is_write) begin

      if (payload_bits > MAX_DATA_WIDTH) begin            

        `uvm_error( "CPU_DRV", $sformatf( "Payload size %0d exceeds maximum %0d bits", payload_bits, MAX_DATA_WIDTH))

        return;

      end


      for (int i = payload_bits - 1; i >= 0; i--) begin

        packet_bits.push_back(req.data[i]);

      end

    end
    else begin

      // Read packet contains 8'h00 DATA field
      for (int i = 7; i >= 0; i--) begin

        packet_bits.push_back(1'b0);

      end

    end


   
    for (int i = 7; i >= 0; i--) begin

      packet_bits.push_back(EOP[i]);

    end

  endfunction

  virtual function void group_bits_into_data(
    input bit packet_bits[$],
    ref bit [FIFO_DATA_WIDTH-1:0] data_words[$]
  );

    int total_bits;
    int word_count;
    int bit_index;


    data_words.delete();

    total_bits = packet_bits.size();

    word_count = (total_bits + FIFO_DATA_WIDTH - 1) / FIFO_DATA_WIDTH;

    bit_index = 0;


    for (int word = 0;
         word < word_count;
         word++) begin

      data_words.push_back('0);

      for (int bit_pos = 0;
           bit_pos < FIFO_DATA_WIDTH;
           bit_pos++) begin

        if (bit_index < total_bits) begin

          data_words[word][bit_pos] =
            packet_bits[bit_index];

          bit_index++;

        end

      end

    end

  endfunction


  virtual task drive_data(
    input bit [FIFO_DATA_WIDTH-1:0] data_words[$]
  );

    foreach (data_words[i]) begin

      // wait until FIFO can accept data
      while (vif.drv_cb.full) begin

        vif.drv_cb.wr_en   <= 1'b0;
        vif.drv_cb.wr_data <= '0;

        @(vif.drv_cb);

      end


      // Drive current data word
      vif.drv_cb.wr_data <= data_words[i];
      vif.drv_cb.wr_en   <= 1'b1;


      // ohld for one clock cycle
      @(vif.drv_cb);


      // Deassert write enable
      vif.drv_cb.wr_en   <= 1'b0;
      vif.drv_cb.wr_data <= '0;

    end

  endtask


endclass
