interface cpu_if(input logic clk);

  logic rst;
  logic wr_en;
  logic [127:0] wr_data;
  logic full;

  logic rd_en;
  logic [127:0] rd_data;
  logic empty;


  // driver clocking block
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;

    output wr_en;
    output wr_data;
    output rd_en;
    input  full;
    input  empty;
    input  rst;
  endclocking


  // monitor clocking block
  clocking mon_cb @(posedge clk);
    default input #1step;

    input rst;

    input wr_en;
    input wr_data;
    input full;
    input rd_en;
    input rd_data;
    input empty;
  endclocking


  modport DRIVER (
    clocking drv_cb
  );

  modport MONITOR (
    clocking mon_cb
  );

endinterface
