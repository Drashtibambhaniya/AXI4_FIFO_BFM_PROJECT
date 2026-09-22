package defines;

  parameter int FIFO_DATA_WIDTH = 128;
  parameter int FIFO_DEPTH = 4096;

  parameter int TXN_ID_WIDTH = 4;
  parameter int ADDR_WIDTH = 32;
  parameter int LEN_WIDTH = 4;
  parameter int SIZE_WIDTH = 3;
  parameter int BURST_WIDTH = 2;
  parameter int LOCK_WIDTH = 2;
  parameter int CACHE_WIDTH = 2;
  parameter int PROT_WIDTH = 3;
  parameter int STRB_WIDTH = 4;

  parameter int MAX_DATA_WIDTH = 1024;

  parameter bit [7:0] SOP = 8'hAA;
  parameter bit [7:0] EOP = 8'h53;

endpackage
