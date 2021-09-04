class router_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(router_virtual_sequence)

router_virtual_sequencer v_seqr;
router_wr_sequencer wr_seqr[];
router_rd_sequencer rd_seqr[];
router_env_config m_cfg;

extern function new(string name = "router_virtual_sequence");
extern task body;

endclass

function router_virtual_sequence::new(string name = "router_virtual_sequence");
super.new(name);
endfunction

task router_virtual_sequence::body();
if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
`uvm_fatal("VIRTUAL_SEQUENCE","Cannot get config database")

$cast(v_seqr,m_sequencer);
wr_seqr = new[m_cfg.no_of_source];
rd_seqr = new[m_cfg.no_of_destination];

foreach(wr_seqr[i])
        wr_seqr[i] = v_seqr.wr_seqrh[i];

foreach(rd_seqr[i])
        rd_seqr[i] = v_seqr.rd_seqrh[i];

endtask
class router_small_pkt_vseq extends router_virtual_sequence;

        `uvm_object_utils(router_small_pkt_vseq);

        bit [1:0]addr;
        router_wr_small_pkt wrtns;
        router_rd_sequence rdtns;

        extern function new(string name="router_small_pkt_vseq");
        extern task body();

endclass


function router_small_pkt_vseq::new(string name="router_small_pkt_vseq");
        super.new(name);
endfunction

task router_small_pkt_vseq::body();

        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting the configuration failed check if set properly")
        if(m_cfg.has_wagent)
                wrtns = router_wr_small_pkt::type_id::create("wrtns");
        if(m_cfg.has_ragent)
                rdtns = router_rd_sequence::type_id::create("rdtns");
        $display("addr (vseq) = %0d",addr);
        fork
                begin
                        wrtns.start(wr_seqr[0]);
                end
                begin
                if(addr==2'b00)
                        rdtns.start(rd_seqr[0]);
                if(addr==2'b01)
                        rdtns.start(rd_seqr[1]);
if(addr==2'b10)
                        rdtns.start(rd_seqr[2]);
                end
        join
endtask


class router_medium_pkt_vseq extends router_virtual_sequence;

        `uvm_object_utils(router_medium_pkt_vseq);

        bit [1:0]addr;
        router_wr_medium_pkt wrtns;
        router_rd_sequence rdtns;

        extern function new(string name="router_medium_pkt_vseq");
        extern task body();

endclass
function router_medium_pkt_vseq::new(string name="router_medium_pkt_vseq");
        super.new(name);
endfunction

task router_medium_pkt_vseq::body();

        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting the configuration failed check if set properly")
        if(m_cfg.has_wagent)
                wrtns = router_wr_medium_pkt::type_id::create("wrtns");
        if(m_cfg.has_ragent)
                rdtns = router_rd_sequence::type_id::create("rdtns");
        fork
                begin
                        wrtns.start(wr_seqr[0]);
                end
                begin
                if(addr==2'b00)
                        rdtns.start(rd_seqr[0]);
                if(addr==2'b01)
                        rdtns.start(rd_seqr[1]);
                if(addr==2'b10)
                        rdtns.start(rd_seqr[2]);
                end
        join
endtask
class router_big_pkt_vseq extends router_virtual_sequence;

        `uvm_object_utils(router_big_pkt_vseq);

        bit [1:0]addr;
        router_wr_big_pkt wrtns;
        router_rd_sequence rdtns;

        extern function new(string name="router_big_pkt_vseq");
        extern task body();

endclass


function router_big_pkt_vseq::new(string name="router_big_pkt_vseq");
        super.new(name);
endfunction
task router_big_pkt_vseq::body();

        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting the configuration failed check if set properly")
        if(m_cfg.has_wagent)
                wrtns = router_wr_big_pkt::type_id::create("wrtns");
        if(m_cfg.has_ragent)
                rdtns = router_rd_sequence::type_id::create("rdtns");
        fork
                begin
                        wrtns.start(wr_seqr[0]);
                end
                begin
                if(addr==2'b00)
                        rdtns.start(rd_seqr[0]);
                if(addr==2'b01)
                        rdtns.start(rd_seqr[1]);
                if(addr==2'b10)
                        rdtns.start(rd_seqr[2]);
                end
        join
endtask



class router_rndm_pkt_vseq extends router_virtual_sequence;

        `uvm_object_utils(router_rndm_pkt_vseq);

        bit [1:0]addr;
        router_wr_random_pkt wrtns;
        router_rd_sequence rdtns;

        extern function new(string name="router_rndm_pkt_vseq");
        extern task body();

endclass
function router_rndm_pkt_vseq::new(string name="router_rndm_pkt_vseq");
        super.new(name);
endfunction

task router_rndm_pkt_vseq::body();

        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting the configuration failed check if set properly")
        if(m_cfg.has_wagent)
                wrtns = router_wr_random_pkt::type_id::create("wrtns");
        if(m_cfg.has_ragent)
                rdtns = router_rd_sequence::type_id::create("rdtns");

        fork
                begin
                        wrtns.start(wr_seqr[0]);
                end
                begin
                if(addr==2'b00)
                        rdtns.start(rd_seqr[0]);
                if(addr==2'b01)
                        rdtns.start(rd_seqr[1]);
                if(addr==2'b10)
                        rdtns.start(rd_seqr[2]);
                end
        join
endtask

class router_time_out_pkt_vseq extends router_virtual_sequence;

        `uvm_object_utils(router_time_out_pkt_vseq);

        bit [1:0]addr;
        router_wr_random_pkt wrtns;
        router_rxtns2 rdtns;
 extern function new(string name="router_time_out_pkt_vseq");
        extern task body();

endclass


function router_time_out_pkt_vseq::new(string name="router_time_out_pkt_vseq");
        super.new(name);
endfunction

task router_time_out_pkt_vseq::body();

        super.body();
        if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
                `uvm_fatal(get_type_name(),"getting the configuration failed check if set properly")
        if(m_cfg.has_wagent)
                wrtns = router_wr_random_pkt::type_id::create("wrtns");
        if(m_cfg.has_ragent)
                rdtns = router_rxtns2::type_id::create("rdtns");

        fork
                begin
                        wrtns.start(wr_seqr[0]);
                end
                begin
                if(addr==2'b00)
                        rdtns.start(rd_seqr[0]);
                if(addr==2'b01)
                        rdtns.start(rd_seqr[1]);
                if(addr==2'b10)
                        rdtns.start(rd_seqr[2]);
                end
        join
endtask
