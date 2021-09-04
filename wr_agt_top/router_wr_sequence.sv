class router_wr_sequence extends uvm_sequence#(write_xtn);
        `uvm_object_utils(router_wr_sequence)

        function new(string name = "router_wr_sequence");
                super.new(name);
        endfunction
endclass



class router_wr_small_pkt extends router_wr_sequence;
        `uvm_object_utils(router_wr_small_pkt)

        bit [1:0] addr;
        function new(string name = "router_wr_small_pkt");
                super.new(name);
        endfunction

        extern task body();
endclass

task router_wr_small_pkt::body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting addr config failed");
        req = write_xtn::type_id::create("req");
        $display("small packet write seqs");

        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;});
                `uvm_info("ROUTER_WR_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
endtask



class router_wr_medium_pkt extends router_wr_sequence;
        `uvm_object_utils(router_wr_medium_pkt)

        bit[1:0]addr;
        function new(string name = "router_wr_medium_pkt");
                super.new(name);
        endfunction

        extern task body();
endclass

task router_wr_medium_pkt::body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting addr config failed");
        req = write_xtn::type_id::create("req");
        $display("medium packet write seqs");

        start_item(req);
        assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] == addr;});
                `uvm_info("ROUTER_WR_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
        finish_item(req);
endtask



class router_wr_big_pkt extends router_wr_sequence;
        `uvm_object_utils(router_wr_big_pkt)

        bit[1:0]addr;
        function new(string name = "router_wr_big_pkt");
                super.new(name);
        endfunction

        extern task body();
endclass
task router_wr_big_pkt::body();

        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"Getting the addr config failed!")
        req = write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[7:2] inside{[31:63]} && header[1:0]==addr;});
                `uvm_info("ROUTER_WR_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
        finish_item(req);
endtask



class router_wr_random_pkt extends router_wr_sequence;
        `uvm_object_utils(router_wr_random_pkt)

        bit[1:0]addr;
        function new(string name = "router_wr_random_pkt");
                super.new(name);
        endfunction

        extern task body();
endclass

task router_wr_random_pkt::body();

        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"Getting the addr config failed!")
        req = write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {header[7:2] inside{[31:63]} && header[1:0]==addr;});
                `uvm_info("ROUTER_WR_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
        finish_item(req);
endtask
