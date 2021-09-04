class router_rd_agt_config extends uvm_object;
        `uvm_object_utils(router_rd_agt_config)

        uvm_active_passive_enum is_active = UVM_ACTIVE;
        virtual router_if vif;

        static int mon_rcvd_xtn_cnt = 0;
        static int drv_data_count = 0;

        function new(string name="router_rd_agt_config");
                super.new(name);
        endfunction
endclass