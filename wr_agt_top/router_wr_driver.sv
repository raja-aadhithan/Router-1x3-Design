class router_wr_driver extends uvm_driver#(write_xtn);
        `uvm_component_utils(router_wr_driver)

        virtual router_if.WDR_MP vif;
        router_wr_agt_config m_cfg;

        extern function new(string name="router_wr_driver",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task drive(write_xtn xtn);
        extern function void report_phase(uvm_phase phase);
endclass

//------constructor------
function router_wr_driver::new(string name="router_wr_driver",uvm_component parent);
        super.new(name,parent);
endfunction

//------build_phase------
function void router_wr_driver::build_phase(uvm_phase phase);
        if(!uvm_config_db#(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))
                `uvm_fatal("WR_DRIVER","Cannot get config database")
        super.build_phase(phase);
endfunction

//------connect_phase------
function void router_wr_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = m_cfg.vif;
endfunction

//-------run_phase------
task router_wr_driver::run_phase(uvm_phase phase);

        $display("before cb");
        @(vif.wdr_cb);
                vif.wdr_cb.resetn<=0;
        @(vif.wdr_cb);
                vif.wdr_cb.resetn<=1;
        $display("run_phase of driver started");

        forever begin
                seq_item_port.get_next_item(req);
                drive(req);
                seq_item_port.item_done;
        end
endtask

//------drive task------
task router_wr_driver::drive(write_xtn xtn);
        `uvm_info("ROUTER WR DRIVER",$sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW)

        @(vif.wdr_cb);
        $display("busy = %b",vif.wdr_cb.busy);
        wait(!vif.wdr_cb.busy)
        vif.wdr_cb.pkt_valid <= 1;
        vif.wdr_cb.data_in <= xtn.header;

        @(vif.wdr_cb);
        foreach(xtn.payload_data[i])    begin
                        wait(!vif.wdr_cb.busy)
                        vif.wdr_cb.data_in <= xtn.payload_data[i];
                        @(vif.wdr_cb);
        end
 wait(!vif.wdr_cb.busy)
        vif.wdr_cb.pkt_valid <= 0;
        vif.wdr_cb.data_in <= xtn.parity;
        repeat(2)@(vif.wdr_cb);
        m_cfg.drv_data_count++;
endtask


function void router_wr_driver::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("REPORT: Router write driver sent %0d transactions", m_cfg.drv_data_count),UVM_LOW)
endfunction