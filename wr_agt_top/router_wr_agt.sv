class router_wr_agt extends uvm_agent;
`uvm_component_utils(router_wr_agt)

router_wr_driver wr_dr;
router_wr_monitor wr_mon;
router_wr_sequencer wr_seqr;
router_wr_agt_config m_cfg;

extern function new(string name="router_wr_agt",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

//------constructor-------
function router_wr_agt::new(string name="router_wr_agt",uvm_component parent);
super.new(name,parent);
endfunction

//------build_phase------
function void router_wr_agt::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))
`uvm_fatal("WR_AGENT","Cannot get config data base")

wr_mon = router_wr_monitor::type_id::create("wr_mon",this);
if(m_cfg.is_active==UVM_ACTIVE)
        begin
        wr_dr = router_wr_driver::type_id::create("wr_dr",this);
        wr_seqr = router_wr_sequencer::type_id::create("wr_seqr",this);
        end
endfunction
//-------connect_phase------
function void router_wr_agt::connect_phase(uvm_phase phase);
if(m_cfg.is_active==UVM_ACTIVE)
        begin
        wr_dr.seq_item_port.connect(wr_seqr.seq_item_export);
        end
endfunction

//-------run_phase------
task router_wr_agt::run_phase(uvm_phase phase);
uvm_top.print_topology;
endtask
