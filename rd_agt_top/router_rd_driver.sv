class router_rd_driver extends uvm_driver#(read_xtn);
        `uvm_component_utils(router_rd_driver)

        virtual router_if.RDR_MP vif;
        router_rd_agt_config m_cfg;

        extern function new(string name="router_rd_driver",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase);
        extern task drive(read_xtn xtn);
        extern function void report_phase(uvm_phase phase);
endclass

//------constructor------
function router_rd_driver::new(string name="router_rd_driver",uvm_component parent);
super.new(name,parent);
endfunction

//------build_phase------
function void router_rd_driver::build_phase(uvm_phase phase);
if(!uvm_config_db#(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
`uvm_fatal("RD_DRIVER","Cannot get config Database")
super.build_phase(phase);
endfunction

//------connect_phase-----
function void router_rd_driver::connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
endfunction


//------run_phase-----
task router_rd_driver::run_phase(uvm_phase phase);
forever
        begin
        seq_item_port.get_next_item(req);
        drive(req);
        seq_item_port.item_done;
        end
endtask

//------drive-----
task router_rd_driver::drive(read_xtn xtn);
        `uvm_info("ROUTER RD DRIVER", $sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW)

        @(vif.rdr_cb);
        wait (vif.rdr_cb.vld_out)
                repeat(xtn.no_of_cycles) @(vif.rdr_cb);
                vif.rdr_cb.read_enb <= 1;
        wait(!vif.rdr_cb.vld_out)
                vif.rdr_cb.read_enb <= 0;
        m_cfg.drv_data_count++;
        @(vif.rdr_cb);
endtask

function void router_rd_driver::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("REPORT: Router write driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction