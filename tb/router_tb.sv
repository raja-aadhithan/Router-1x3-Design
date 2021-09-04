class router_tb extends uvm_env;
`uvm_component_utils(router_tb)

router_wr_agt_top wagt_top;
router_rd_agt_top ragt_top;
router_virtual_sequencer v_sequencer;
router_scoreboard sb;
router_env_config m_cfg;

extern function new(string name = "router_tb",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: router_tb

//------construction function------
function router_tb::new(string name = "router_tb",uvm_component parent);
super.new(name,parent);
endfunction: new

//-----build_phase function-----
function void router_tb::build_phase(uvm_phase phase);

if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
`uvm_fatal("CONFIG","Cannot get() config from database. Have you set() it")

super.build_phase(phase);

if(m_cfg.has_wagent)
        begin
        wagt_top = router_wr_agt_top::type_id::create("wagt_top",this);
        end

if(m_cfg.has_ragent)
        begin
        ragt_top = router_rd_agt_top::type_id::create("ragt_top",this);
        end
if(m_cfg.has_virtual_sequencer)
        v_sequencer = router_virtual_sequencer::type_id::create("v_sequencer",this);

if(m_cfg.has_scoreboard)
        sb = router_scoreboard::type_id::create("sb",this);

endfunction

//------connect_phase------

function void router_tb::connect_phase(uvm_phase phase);
super.connect_phase(phase);

if(m_cfg.has_virtual_sequencer)
        begin
        foreach(v_sequencer.wr_seqrh[i])
        v_sequencer.wr_seqrh[i] = wagt_top.wagth[i].wr_seqr;

        foreach(v_sequencer.rd_seqrh[i])
        v_sequencer.rd_seqrh[i] = ragt_top.ragth[i].rd_seqr;
        end

if(m_cfg.has_scoreboard)
        begin
        wagt_top.wagth[0].wr_mon.ap_w.connect(sb.af_w.analysis_export);
        foreach(ragt_top.ragth[i])
        ragt_top.ragth[i].rd_mon.ap_r.connect(sb.af_r[i].analysis_export);
        end

endfunction