class router_rd_monitor extends uvm_monitor;
`uvm_component_utils(router_rd_monitor)

virtual router_if.RMON_MP vif;
router_rd_agt_config m_cfg;
uvm_analysis_port#(read_xtn) ap_r;

extern function new(string name="router_rd_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);
endclass

//------constructor------
function router_rd_monitor::new(string name="router_rd_monitor",uvm_component parent);
super.new(name,parent);
ap_r = new("ap_r",this);
endfunction

//------build_phase------
function void router_rd_monitor::build_phase(uvm_phase phase);
if(!uvm_config_db#(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
`uvm_fatal("RD_MONITOR","Cannot get config database")
super.build_phase(phase);
endfunction

//------connect_phase------
function void router_rd_monitor::connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
endfunction


//-------run_phase------
task router_rd_monitor::run_phase(uvm_phase phase);
forever
        collect_data();
endtask

//------drive task------
task router_rd_monitor::collect_data();
        read_xtn mon_data;
        begin
                mon_data = read_xtn::type_id::create("mon_data");
                @(vif.rmon_cb);
                wait(vif.rmon_cb.read_enb)
                @(vif.rmon_cb);
                        mon_data.header = vif.rmon_cb.data_out;
                        mon_data.payload_data = new[mon_data.header[7:2]];
                @(vif.rmon_cb);
                foreach(mon_data.payload_data[i])
                        begin
                                mon_data.payload_data[i] = vif.rmon_cb.data_out;
                                @(vif.rmon_cb);
                        end
                        mon_data.parity = vif.rmon_cb.data_out;
                @(vif.rmon_cb);

                m_cfg.mon_rcvd_xtn_cnt++;
                        `uvm_info("router_rd_MONITOR",$sformatf("printing from monitor \n %s",mon_data.sprint()),UVM_LOW)
                ap_r.write(mon_data);
        end

endtask

function void router_rd_monitor::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("REPORT: Router write monitor received %0d transactions", m_cfg.mon_rcvd_xtn_cnt),UVM_LOW)
endfunction