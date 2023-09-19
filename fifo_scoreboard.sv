class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(fifo_sequence_item, fifo_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)
//   int counter;
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit [127:0] check_fifo[$];
  
  function void write(input fifo_sequence_item item_got);
    bit [127:0] testdata;
    if(item_got.i_wren == 'b1)begin
      if(check_fifo.size < 1024) begin
//       counter = counter+1;
      check_fifo.push_back(item_got.i_wrdata);
        `uvm_info("write Data", $sformatf("time = %0d write enable: %0b read enable: %0b write data: %d full: %0b, almost empty: %0d, almost full: %0d",$time,item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_empty, item_got.o_alm_full), UVM_LOW);
        $display("queue is %p and size is %0d",check_fifo,check_fifo.size);
      end
      else begin
        $display("--------REFERENCE FIFO IS FULL--------"); 
         //If assertion isn't present
        if(item_got.o_full == 1)
          $display("FULL condition is satisfied");
        else
          $display("FULL condition isn't satisfied");
        `uvm_info("write Data", $sformatf("time = %0d write enable: %0b read enable: %0b write data: %d full: %0b, almost empty: %0d, almost full: %0d",$time,item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full, item_got.o_alm_empty, item_got.o_alm_full), UVM_LOW);
      end
    end
    if (item_got.i_rden == 'b1)begin
      if(check_fifo.size() >= 'd1)begin
//         counter = counter-1;
        testdata = check_fifo.pop_front();
        `uvm_info("Read Data", $sformatf("time = %0d testdata: %d read data : %d empty: %0b, almost empty: %0d, almost full: %0d", $time,testdata, item_got.o_rddata, item_got.o_empty, item_got.o_alm_empty, item_got.o_alm_full), UVM_LOW);
        $display("queue is %p and size is %0d",check_fifo,check_fifo.size);
        if(testdata == item_got.o_rddata)begin
          $display("--------MATCH SUCCESSFUL----------");
        end
        else begin
          $display("--------MATCH UNSUCCESSFUL--------");
        end
      end
      else begin
        $display("--------REFERENCE FIFO IS EMPTY--------");
        //If assertion isn't present
        if(item_got.o_empty == 1)
          $display("EMPTY condition is satisfied");
        else
          $display("EMPTY condition isn't satisfied");
        `uvm_info("Read Data", $sformatf("time = %0d testdata: %0h read data : %0h empty: %0b, almost empty: %0d, almost full: %0d", $time,testdata, item_got.o_rddata, item_got.o_empty, item_got.o_alm_empty, item_got.o_alm_full), UVM_LOW);
      end
    end
    //If assertion isn't present
    if(check_fifo.size >= 4 && check_fifo.size<8) begin
      $display("-------REFERENCE FIFO IS ALMOST FULL--------");
      if(item_got.o_alm_full == 1)
      $display("ALMOST FULL condition is satisfied");
     else
      $display("ALMOST FULL condition isn't satisfied");
    end
    if((check_fifo.size <= 2) && (check_fifo.size>0)) begin
      $display("--------REFERENCE FIFO IS ALMOST EMPTY--------");
      if(item_got.o_alm_empty == 1)
      $display("ALMOST EMPTY condition is satisfied");
     else
      $display("ALMOST EMPTY condition isn't satisfied");
    end
  endfunction
endclass
        