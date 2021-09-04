class router_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(router_scoreboard);

        uvm_tlm_analysis_fifo#(write_xtn) af_w;
        uvm_tlm_analysis_fifo#(read_xtn) af_r[];

        router_env_config m_cfg;
        write_xtn wr_data, write_cov_data;
        read_xtn rd_data,read_cov_data;
        bit[1:0] addr;
        int data_verified_count;

        covergroup router_fcov1;
                option.per_instance = 1;

                CHANNEL : coverpoint write_cov_data.header[1:0] { bins low = {2'b00};
                                                                  bins mid = {2'b01};
                                                                  bins high = {2'b10};}
                PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2] {   bins small_packet = {[1:15]};                                                                                                                                       bins medium_packet = {[16:30]};
                                                                         bins large_packet = {[31:63]};}
                BAD_PKT : coverpoint write_cov_data.error{bins bad_pkt = {0};}

                CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL, PAYLOAD_SIZE;
                CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT : cross CHANNEL, PAYLOAD_SIZE, BAD_PKT;
        endgroup
covergroup router_fcov2;
                option.per_instance = 1;

                CHANNEL : coverpoint read_cov_data.header[1:0] { bins low = {2'b00};
                                                                  bins mid = {2'b01};
                                                                  bins high = {2'b10};}
                PAYLOAD_SIZE : coverpoint read_cov_data.header[7:2] {   bins small_packet = {[1:15]};                                                                                                                                        bins medium_packet = {[16:30]};
                                                                         bins large_packet = {[31:63]};}
                CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL, PAYLOAD_SIZE;
        endgroup

        extern function new(string name="router_scoreboard",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern function void check_data(read_xtn rd);
endclass

//------constructor------
function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
        super.new(name,parent);
        router_fcov1 = new;
        router_fcov2 = new;
endfunction

//------Build Phase ------
function void router_scoreboard::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal("SCOREBOARD","cannot get config data");

        af_r = new[m_cfg.no_of_destination];
        af_w = new("af_w",this);

        foreach(af_r[i])
                af_r[i] = new($sformatf("af_r[%0d]",i),this);

endfunction
task router_scoreboard::run_phase(uvm_phase phase);
        fork
                begin forever begin
                        af_w.get(wr_data);
                        `uvm_info("WRITE_SB", "write_data", UVM_LOW)

                        wr_data.print;
                        write_cov_data = wr_data;

                        router_fcov1.sample();
                end     end

                begin forever begin
                        if(addr == 2'b00)       af_r[0].get(rd_data);
                        if(addr == 2'b01)       af_r[1].get(rd_data);
                        if(addr == 2'b10)      af_r[2].get(rd_data);

                        `uvm_info("READ SB[0]","read_data",UVM_LOW)
                        rd_data.print;
                        check_data(rd_data);
                        read_cov_data = rd_data;

                        router_fcov2.sample();
                end     end
        join
endtask

function void router_scoreboard::check_data(read_xtn rd);
        if(wr_data.header == rd.header)
                `uvm_info("SB","HEADER MATCHED SUCCESS",UVM_MEDIUM)
        else
                `uvm_error("SB","HEADER MISMATCH")
if(wr_data.payload_data == rd.payload_data)
                `uvm_info("SB","PAYLOAD MATCH SUCCESS",UVM_MEDIUM)
        else
                `uvm_info("SB","PAYLOAD MATCH FAIL",UVM_MEDIUM)


        if(wr_data.parity == rd.parity)
                `uvm_info("SB","PARITY MATCH SUCCESS",UVM_MEDIUM)
        else
                `uvm_error("SB","PARITY COMPARISON FAILED")

        data_verified_count++;

endfunction