class fifo_driver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_interface vif;
  //fifo_sequence_item req;
  `uvm_component_utils(fifo_driver)
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "No vif is found!")
  endfunction

  virtual task run_phase(uvm_phase phase);    
    forever begin
      if(vif.rstn == 0)   
    repeat(1) @(vif.d_cb) begin
    vif.d_mp.d_cb.i_wren <= 1'b0;
    vif.d_mp.d_cb.i_rden <= 1'b0;
    vif.d_mp.d_cb.i_wrdata <= 1'b0;
      end
      else begin
      seq_item_port.get_next_item(req);
      if(req.i_wren == 1) 
        main_write(req.i_wrdata);
      if(req.i_rden == 1)
        main_read();
      seq_item_port.item_done();
      end
    end
  endtask
  
    virtual task main_write(input [127:0] din);
      @(posedge vif.d_mp.clk) begin
    vif.d_mp.d_cb.i_wren <= 1'b1;
    vif.d_mp.d_cb.i_wrdata <= din;
      end
     @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_wren <= 1'b0;
  endtask
  
  virtual task main_read();
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_rden <= 1'b1;
    @(posedge vif.d_mp.clk)
    vif.d_mp.d_cb.i_rden <= 1'b0;
  endtask

endclass
  
   