class router_wr_agt_config extends uvm_object;
        `uvm_object_utils(router_wr_agt_config)

        virtual router_if vif;
        uvm_active_passive_enum is_active = UVM_ACTIVE;

        static int mon_rcvd_xtn_cnt = 0;
        static int drv_data_count = 0;

        function new(string name="router_wr_agt_config");
                super.new(name);
        endfunction
endclass: router_wr_agt_config