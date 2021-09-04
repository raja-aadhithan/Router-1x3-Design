class router_wr_monitor extends uvm_monitor;
        `uvm_component_utils(router_wr_monitor)

        virtual router_if.WMON_MP vif;
        router_wr_agt_config m_cfg;
        uvm_analysis_port#(write_xtn) ap_w;
        write_xtn xtn;

        extern function new(string name="router_wr_monitor",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();
        extern function void report_phase(uvm_phase phase);
endclass

//------constructor------
function router_wr_monitor::new(string name="router_wr_monitor",uvm_component parent);
        super.new(name,parent);
        ap_w = new("ap_w",this);
endfunction

//------build_phase------
function void router_wr_monitor::build_phase(uvm_phase phase);
        if(!uvm_config_db#(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))
                `uvm_fatal("WR_MONITOR","Cannot get config database")
        super.build_phase(phase);
endfunction

//------connect_phase------
function void router_wr_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = m_cfg.vif;
endfunction

//-------run_phase------
task router_wr_monitor::run_phase(uvm_phase phase);
        forever
                collect_data();
endtask

//------drive task------
task router_wr_monitor::collect_data();
        write_xtn mon_data;
        begin
                mon_data = write_xtn::type_id::create("mon_data");

                @(vif.wmon_cb);
                wait(!vif.wmon_cb.busy && vif.wmon_cb.pkt_valid)
                mon_data.header = vif.wmon_cb.data_in;
                mon_data.payload_data = new[mon_data.header[7:2]];

                @(vif.wmon_cb);
                foreach(mon_data.payload_data[i])  begin
                        wait(!vif.wmon_cb.busy)
                        mon_data.payload_data[i] = vif.wmon_cb.data_in;
                        @(vif.wmon_cb);
                end

                wait(!vif.wmon_cb.pkt_valid && !vif.wmon_cb.busy)
                mon_data.parity = vif.wmon_cb.data_in;

                repeat(2)@(vif.wmon_cb);
                        mon_data.error = vif.wmon_cb.error;

                m_cfg.mon_rcvd_xtn_cnt++;
                        `uvm_info("ROUTER_WR_MONITOR",$sformatf("printing from monitor \n %s",mon_data.sprint()),UVM_LOW)

                ap_w.write(mon_data);
        end

endtask

function void router_wr_monitor::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("REPORT: Router write monitor received %0d transactions", m_cfg.mon_rcvd_xtn_cnt),UVM_LOW)
endfunction