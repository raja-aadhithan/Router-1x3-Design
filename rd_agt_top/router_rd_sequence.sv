class router_rd_sequence extends uvm_sequence#(read_xtn);
`uvm_object_utils(router_rd_sequence)

extern function new(string name = "router_rd_sequence");
endclass

function router_rd_sequence::new(string name = "router_rd_sequence");
super.new(name);
endfunction

class router_rxtns extends router_rd_sequence;

        `uvm_object_utils(router_rxtns)

        extern function new(string name = "router_rxtns");
        extern task body();

endclass


function router_rxtns::new(string name = "router_rxtns");
        super.new(name);
endfunction


task router_rxtns::body();
        super.body();
        req = read_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {no_of_cycles inside {[1:20]};});
                `uvm_info("ROUTER_RD_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);

endtask


class router_rxtns2 extends router_rd_sequence;

        `uvm_object_utils(router_rxtns2)

        extern function new(string name = "router_rxtns2");
        extern task body();

endclass


function router_rxtns2::new(string name = "router_rxtns2");
        super.new(name);
endfunction


task router_rxtns2::body();
        super.body();
        req = read_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {no_of_cycles inside {[30:40]};});
                `uvm_info("ROUTER_RD_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);

endtask