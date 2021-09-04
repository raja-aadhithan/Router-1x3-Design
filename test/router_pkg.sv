package router_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

//`include "tb_defs.sv"
`include "write_xtn.sv"
`include "router_wr_agt_config.sv"
`include "router_rd_agt_config.sv"
`include "router_env_config.sv"
`include "router_wr_driver.sv"
`include "router_wr_monitor.sv"
`include "router_wr_sequencer.sv"
`include "router_wr_agt.sv"
`include "router_wr_agt_top.sv"
`include "router_wr_sequence.sv"

`include "read_xtn.sv"
`include "router_rd_monitor.sv"
`include "router_rd_sequencer.sv"
`include "router_rd_sequence.sv"
`include "router_rd_driver.sv"
`include "router_rd_agt.sv"
`include "router_rd_agt_top.sv"

`include "router_virtual_sequencer.sv"
`include "router_virtual_sequence.sv"
`include "router_scoreboard.sv"

`include "router_tb.sv"


`include "router_vtest_lib.sv"
endpackage