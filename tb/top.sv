module top;

import router_pkg::*;
import uvm_pkg::*;

bit clock;
initial
        begin
        clock = 1'b1;
        forever #5 clock = ~clock;
        end

router_if in(clock);
router_if in0(clock);
router_if in1(clock);
router_if in2(clock);

//-----wrong---router_top DUV(.data_in(in.data_in), .pkt_valid(in.pkt_valid), .clock(clk), .resetn(in.resetn), .error(in.error), .busy(in.busy),
router_top DUV(.data_in(in.data_in), .pkt_valid(in.pkt_valid), .resetn(in.resetn), .error(in.error), .busy(in.busy),
               .read_enb_0(in0.read_enb), .read_enb_1(in1.read_enb), .read_enb_2(in2.read_enb),
               .data_out_0(in0.data_out), .data_out_1(in1.data_out), .data_out_2(in2.data_out),
               .valid_out_0(in0.vld_out),   .valid_out_1(in1.vld_out),   .valid_out_2(in2.vld_out));

initial
        begin
        uvm_config_db#(virtual router_if)::set(null,"*","vif",in);
        uvm_config_db#(virtual router_if)::set(null,"*","vif[0]",in0);
        uvm_config_db#(virtual router_if)::set(null,"*","vif[1]",in1);
        uvm_config_db#(virtual router_if)::set(null,"*","vif[2]",in2);

        run_test();
        end

endmodule
