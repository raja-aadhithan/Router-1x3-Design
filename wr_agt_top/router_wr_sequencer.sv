class router_wr_sequencer extends uvm_sequencer #(write_xtn);
`uvm_component_utils(router_wr_sequencer);
extern function new(string name="router_wr_sequencer",uvm_component parent);
endclass

function router_wr_sequencer::new(string name="router_wr_sequencer",uvm_component parent);
        super.new(name,parent);
endfunction