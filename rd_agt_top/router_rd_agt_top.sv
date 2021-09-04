class router_rd_agt_top extends uvm_env;
`uvm_component_utils(router_rd_agt_top)

router_env_config m_cfg;
router_rd_agt_config rcfg[];
router_rd_agt ragth[];

extern function new(string name="router_rd_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

//------constructor------
function router_rd_agt_top::new(string name="router_rd_agt_top",uvm_component parent);
super.new(name,parent);
endfunction

//------Build_phase------
function void router_rd_agt_top::build_phase(uvm_phase phase);
if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("RD_AGT_TOP","Cannot get Database")

rcfg = new[m_cfg.no_of_destination];
ragth = new[m_cfg.no_of_destination];

foreach(ragth[i])
        begin
        rcfg[i] = router_rd_agt_config::type_id::create($sformatf("rcfg[%0d]",i),this);
        rcfg[i] = m_cfg.m_rd_agt_cfg[i];
        ragth[i] = router_rd_agt::type_id::create($sformatf("ragth[%0d]",i),this);
        uvm_config_db#(router_rd_agt_config)::set(this,$sformatf("ragth[%0d]*",i),"router_rd_agt_config",rcfg[i]);
        end
endfunction
