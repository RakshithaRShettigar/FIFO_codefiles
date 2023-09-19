class fifo_agent extends uvm_agent;
  fifo_sequencer f_seqr;
  fifo_driver f_dri;
  fifo_monitor f_mon;
  `uvm_component_utils(fifo_agent)
  
  function new(string name = "fifo_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      f_seqr = fifo_sequencer::type_id::create("f_seqr", this);
      f_dri = fifo_driver::type_id::create("f_dri", this);
    end
    f_mon = fifo_monitor::type_id::create("f_mon", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE)
      f_dri.seq_item_port.connect(f_seqr.seq_item_export);
  endfunction
endclass
    
    