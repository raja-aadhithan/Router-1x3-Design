class router_wr_agt_top extends uvm_env;
`uvm_component_utils(router_wr_agt_top)

router_wr_agt wagth[];
router_wr_agt_config wcfg[];
router_env_config m_cfg;

extern function new(string name="router_wr_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass

//-------constructor-------
function router_wr_agt_top::new(string name="router_wr_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

//------build_phase------
function void router_wr_agt_top::build_phase(uvm_phase phase);

if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("WR_AGT_TOP","Cannot get config data")

wagth = new[m_cfg.no_of_source];
wcfg = new[m_cfg.no_of_source];

foreach(wagth[i])
        begin
        wcfg[i] = router_wr_agt_config::type_id::create($sformatf("wcfg[i]",i));
        wcfg[i] = m_cfg.m_wr_agt_cfg[i];
        wagth[i] = router_wr_agt::type_id::create($sformatf("wagth[%0d]",i),this);
        uvm_config_db#(router_wr_agt_config)::set(this,$sformatf("wagth[%0d]*",i),"router_wr_agt_config",wcfg[i]);
        end
endfunction