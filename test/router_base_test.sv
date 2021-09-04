class router_base_test extends uvm_test;
`uvm_component_utils(router_base_test)

router_tb router_env;
router_env_config m_tb_cfg;
router_wr_agt_config m_wr_cfg[];
router_rd_agt_config m_rd_cfg[];

int has_ragent = 1;
int has_wagent = 1;
int no_of_source = 1;
int no_of_destination = 3;
int has_scoreboard = 1;
int has_virtual_sequencer = 1;

extern function new(string name = "router_base_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

//------constructor------
function router_base_test::new(string name = "router_base_test",uvm_component parent);
super.new(name,parent);
endfunction

//------Build_phase------
function void router_base_test::build_phase(uvm_phase phase);
m_wr_cfg = new[no_of_source];
m_rd_cfg = new[no_of_destination];
m_tb_cfg = router_env_config::type_id::create("m_tb_cfg",this);
m_tb_cfg.m_wr_agt_cfg = new[no_of_source];
m_tb_cfg.m_rd_agt_cfg = new[no_of_destination];
foreach(m_wr_cfg[i])
        begin
        m_wr_cfg[i]=router_wr_agt_config::type_id::create($sformatf("WR_AGENT_CONFIG[%0d]",i));
        if(!uvm_config_db #(virtual router_if)::get(this,"","vif",m_wr_cfg[i].vif))
        `uvm_fatal("TEST","cannot get config data");
        m_wr_cfg[i].is_active=UVM_ACTIVE;
        m_tb_cfg.m_wr_agt_cfg[i] = m_wr_cfg[i];
        end
foreach(m_rd_cfg[i])
        begin
        m_rd_cfg[i]=router_rd_agt_config::type_id::create($sformatf("RD_AGENT_CONFIG[%0d]",i));
        if(!uvm_config_db #(virtual router_if)::get(this,"","vif",m_rd_cfg[i].vif))
        `uvm_fatal("TEST","cannot get config data");
        m_rd_cfg[i].is_active=UVM_ACTIVE;
        m_tb_cfg.m_rd_agt_cfg[i] = m_rd_cfg[i];
        end

m_tb_cfg.has_ragent = has_ragent;
m_tb_cfg.has_wagent = has_wagent;
m_tb_cfg.no_of_source = no_of_source;
m_tb_cfg.no_of_destination = no_of_destination;
m_tb_cfg.has_scoreboard = has_scoreboard;
m_tb_cfg.has_virtual_sequencer = has_virtual_sequencer;

uvm_config_db#(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
super.build_phase(phase);
router_env = router_tb::type_id::create("router_env",this);

endfunction

class router_small_pkt_test extends router_base_test;

        `uvm_component_utils(router_small_pkt_test)
        router_small_pkt_vseq router_seqh;
        //router_wxtns_small_pkt router_seqh;

        bit [1:0] addr;

        extern function new(string name="router_small_pkt_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass
function router_small_pkt_test::new(string name="router_small_pkt_test",uvm_component parent);
        super.new(name,parent);
endfunction

function void router_small_pkt_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task router_small_pkt_test::run_phase(uvm_phase phase);
        repeat(20)
                begin
                        addr = {$random}%3;
                        //addr = 0;
                        uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        $display("addr = %0d",addr);
                        //#1;
                        phase.raise_objection(this);
                        router_seqh = router_small_pkt_vseq::type_id::create("router_seqh");
                        //router_seqh = router_wxtns_small_pkt::type_id::create("router_seqh");
                        router_seqh.start(router_env.v_sequencer);
                        phase.drop_objection(this);
                end
endtask


class router_medium_pkt_test extends router_base_test;

        `uvm_component_utils(router_medium_pkt_test)

        router_medium_pkt_vseq router_seqh;

        bit[1:0]addr;

        extern function new(string name="router_medium_pkt_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass
function router_medium_pkt_test::new(string name="router_medium_pkt_test",uvm_component parent);
        super.new(name,parent);
endfunction

function void router_medium_pkt_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task router_medium_pkt_test::run_phase(uvm_phase phase);
        repeat(20)
                begin
                        addr = {$random}%3;
                        uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        //#1;
                        phase.raise_objection(this);
                        router_seqh = router_medium_pkt_vseq::type_id::create("router_seqh");
                        router_seqh.start(router_env.v_sequencer);
                        phase.drop_objection(this);
                end
endtask



class router_big_pkt_test extends router_base_test;

        `uvm_component_utils(router_big_pkt_test)

        router_big_pkt_vseq router_seqh;

        bit[1:0]addr;

        extern function new(string name="router_big_pkt_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass

function router_big_pkt_test::new(string name="router_big_pkt_test",uvm_component parent);
        super.new(name,parent);
endfunction
function void router_big_pkt_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task router_big_pkt_test::run_phase(uvm_phase phase);
        repeat(20)
                begin
                        addr = {$random}%3;
                        uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        //#1;
                        phase.raise_objection(this);
                        router_seqh = router_big_pkt_vseq::type_id::create("router_seqh");
                        router_seqh.start(router_env.v_sequencer);
                        phase.drop_objection(this);
                end
endtask





class router_rndm_pkt_test extends router_base_test;

        `uvm_component_utils(router_rndm_pkt_test)

        router_rndm_pkt_vseq router_seqh;

        bit[1:0]addr;

        extern function new(string name="router_rndm_pkt_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass

function router_rndm_pkt_test::new(string name="router_rndm_pkt_test",uvm_component parent);
        super.new(name,parent);
endfunction
function void router_rndm_pkt_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction

task router_rndm_pkt_test::run_phase(uvm_phase phase);
        repeat(2)
                begin
                        addr = {$random}%3;
                        uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        //#1;
                        phase.raise_objection(this);
                        router_seqh = router_rndm_pkt_vseq::type_id::create("router_seqh");
                        router_seqh.start(router_env.v_sequencer);
                        phase.drop_objection(this);
                end
endtask


class router_time_out_pkt_test extends router_base_test;

        `uvm_component_utils(router_time_out_pkt_test)

        router_time_out_pkt_vseq router_seqh;

        bit[1:0]addr;

        extern function new(string name="router_time_out_pkt_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass

function router_time_out_pkt_test::new(string name="router_time_out_pkt_test",uvm_component parent);
        super.new(name,parent);
endfunction

function void router_time_out_pkt_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction
task router_time_out_pkt_test::run_phase(uvm_phase phase);
        repeat(20)
                begin
                        addr = {$random}%3;
                        uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
                        //#1;
                        phase.raise_objection(this);
                        router_seqh = router_time_out_pkt_vseq::type_id::create("router_seqh");
                        router_seqh.start(router_env.v_sequencer);
                        phase.drop_objection(this);
                end
endtask
