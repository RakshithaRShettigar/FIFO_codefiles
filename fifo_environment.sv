class fifo_environment extends uvm_env;
  fifo_agent f_agt;
  fifo_scoreboard f_scb;
  `uvm_component_utils(fifo_environment)
  
  function new(string name = "fifo_environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    f_agt = fifo_agent::type_id::create("f_agt", this);
    f_scb = fifo_scoreboard::type_id::create("f_scb", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    f_agt.f_mon.item_got_port.connect(f_scb.item_got_export);
  endfunction
  
endclass