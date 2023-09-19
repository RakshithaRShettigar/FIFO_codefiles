class fifo_sequence extends uvm_sequence#(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
  
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), $sformatf("-------------Performing continuous write operation------------"), UVM_LOW);
    repeat(10) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {{i_wren,i_rden} == 2'b10;});
      finish_item(req);
    end
    #20;
    `uvm_info(get_type_name(), $sformatf("-------------Performing continuous read operation------------"), UVM_LOW);
    repeat(12) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
        assert(req.randomize() with {{i_wren,i_rden} == 2'b01;});
      finish_item(req);
    end
    `uvm_info(get_type_name(), $sformatf("-------------Performing alternate write and read operation------------"), UVM_LOW);
    repeat(12) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {{i_wren,i_rden} == 2'b10;});
      finish_item(req);
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {{i_wren,i_rden} == 2'b01;});
      finish_item(req);
    end
   `uvm_info(get_type_name(), $sformatf("-------------Performing random write and read operation------------"), UVM_LOW);
      repeat(20) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
//   `uvm_info(get_type_name(), $sformatf("-------------Performing simultaneous write and read operation------------"), UVM_LOW); 
//    repeat(10) begin
//       req = fifo_sequence_item::type_id::create("req");
//       start_item(req);
//      assert(req.randomize() with {{i_wren,i_rden} == 2'b11;});
//       finish_item(req);
//     end
//   `uvm_info(get_type_name(), $sformatf("-------------Performing no write and no read operation------------"), UVM_LOW); 
//    repeat(10) begin
//       req = fifo_sequence_item::type_id::create("req");
//       start_item(req);
//      assert (req.randomize() with {{i_wren,i_rden} == 2'b00;});
//       finish_item(req);
//     end
  endtask
  
endclass

               
  