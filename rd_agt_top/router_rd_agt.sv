class router_rd_agt extends uvm_agent;
`uvm_component_utils(router_rd_agt)

router_rd_driver rd_dr;
router_rd_monitor rd_mon;
router_rd_sequencer rd_seqr;
router_rd_agt_config m_cfg;

extern function new(string name="router_rd_agt",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass

//------constructor------
function router_rd_agt::new(string name="router_rd_agt",uvm_component parent);
super.new(name,parent);
endfunction

//------build_phase------
function void router_rd_agt::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
`uvm_fatal("RD_AGT","Cannot get config database")

rd_mon = router_rd_monitor::type_id::create("rd_mon",this);
if(m_cfg.is_active==UVM_ACTIVE)
        begin
        rd_dr = router_rd_driver::type_id::create("rd_dr",this);
        rd_seqr = router_rd_sequencer::type_id::create("rd_seqr",this);
        end
endfunction

//------connect_phase------
function void router_rd_agt::connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(m_cfg.is_active==UVM_ACTIVE)
        begin
        rd_dr.seq_item_port.connect(rd_seqr.seq_item_export);
        end
endfunction

