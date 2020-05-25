// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: Decode Test Bench

module decode_tb();

parameter NOP = 32'b000000000000_00000_000_00000_0010011; // addi zero, zero, 0
parameter ADDRESS_BITS = 16;

// Inputs from Fetch
reg [ADDRESS_BITS-1:0] PC;
reg [31:0] instruction;

// Inputs from Execute/ALU
reg [ADDRESS_BITS-1:0] JALR_target;
reg branch;

// Outputs to Fetch
wire next_PC_select;
wire [ADDRESS_BITS-1:0] target_PC;

// Outputs to Reg File
wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;
wire wEn;

// Outputs to Execute/ALU
wire branch_op; // Tells ALU if this is a branch instruction
wire [31:0] imm32;
wire [1:0] op_A_sel;
wire op_B_sel;
wire [5:0] ALU_Control;

// Outputs to Memory
wire mem_wEn;

// Outputs to Writeback
wire wb_sel;

decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) uut (

  // Inputs from Fetch
  .PC(PC),
  .instruction(instruction),

  // Inputs from Execute/ALU
  .JALR_target(JALR_target),
  .branch(branch),

  // Outputs to Fetch
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),

  // Outputs to Reg File
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .wEn(wEn),

  // Outputs to Execute/ALU
  .branch_op(branch_op), // Tells ALU if this is a branch instruction
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_sel)

);



task print_state;
  begin
    $display("Time:         %0d", $time);
    $display("instruction:  %b", instruction);
    $display("PC:           %h", PC);
    $display("JALR_target:  %h", JALR_target);
    $display("branch        %b", branch);
    $display("next_PC_sel   %b", next_PC_select);
    $display("target_PC     %h", target_PC);
    $display("read_sel1:    %d", read_sel1);
    $display("read_sel2:    %d", read_sel2);
    $display("write_sel:    %d", write_sel);
    $display("wEn:          %b", wEn);
    $display("branch_op:    %b", branch_op);
    $display("imm32:        %b", imm32);
    $display("op_A_sel:     %b", op_A_sel);
    $display("op_B_sel:     %b", op_B_sel);
    $display("ALU_Control:  %b", ALU_Control);
    $display("mem_wEn:      %b", mem_wEn);
    $display("wb_sel:       %b", wb_sel);
    $display("--------------------------------------------------------------------------------");
    $display("\n\n");
  end
endtask



initial begin
  $display("Starting Decode Test");
  $display("--------------------------------------------------------------------------------");
  instruction = NOP;
  PC          = 0;
  JALR_target = 0;
  branch      = 0;

  #10
  // Display output of NOP instruction
  $display("addi zero, zero, 0");
  print_state();
  // Test a new instruction
  instruction = 32'b111111111111_00000_000_01011_0010011; // addi a1, zero, -1

  #10
  // Here we are printing the state of the register file.
  // We should see the result of the add a6, a1, a2 instruction but not the
  // sub a7, a2, a4 instruction because there has not been a posedge clock yet
  $display("addi a1, zero, -1");
  print_state();
  instruction = 32'b0000000_01100_01011_000_10000_0110011; // add a6, a1, a2

  #10
  $display("add a6, a1, a2");
  print_state();
  instruction = 32'b0100000_01110_01100_000_10001_0110011; // sub a7, a2, a4

  #10
  $display("sub a7, a2, a4");
  print_state();
  instruction = 32'b0000000_01111_01011_010_01010_0110011; // slt a0, a1, a5

  #10
  $display("slt a0, a1, a5");
  print_state();
  instruction = 32'b0000000_01111_01011_100_01110_0110011; // xor a4, a1, a5

  #10
  $display("xor a4, a1, a5");
  print_state();
  instruction = 32'b0000000_01011_01101_111_01101_0110011; // and a3, a3, a1

  #10
  $display("and a3, a3, a1");
  print_state();
  instruction = 32'b011000000000_00000_000_01011_0010011; // addi a1, zero, 1536

  #10
  $display("addi a1, zero, 1536");
  print_state();
  instruction = 32'b0000000_01100_01011_010_00000_0100011; // sw a2, 0(a1);

  #10
  $display("sw a2, 0(a1)");
  print_state();
  instruction = 32'b000000000000_01011_010_10010_0000011; // lw s2, 0(a1);
  
  #10
  $display("lw s2, 0(a1)");
  print_state();
  instruction = NOP;

  PC = 16'h0114;
  instruction = 32'h0140006f; //jal	zero,128 (Should jump to 0x128)

  #10
  $display("jal	zero,128");
  print_state();

  JALR_target = 16'h0154;
  PC = 16'h0094;
  instruction = 32'h0c4080e7; // jalr ra,196(ra) (should jump to ra+0x196)

 #10
 $display("jalr ra,196(ra)");
 print_state();
   
 
/******************************************************************************
*                     Add Test Cases Here
******************************************************************************/
 instruction = 32'b0_000000_00000_00000_000_0000_0_1100011; //beq
 branch = 1;
 /* ADD done
    ADDI done
    SUB done
    XOR done
    JAL done
    JALR done
    BEQ done
    SLT done
    SW done 
    LW done
    branch operations good as long as branch = 1
    BNE done
    BLTU done
    BGE done
    BLT done
    BGEU done
    
    
    LUI done 
    AUIPC done

    SLTIU done
    SLTU done
    SRAI done
    SRA done
    SRLdone
    SRLIdone
    SLLdone
    SLLIdone
 */
   
 #10
 $display("beq a0,a0,0");
 print_state();
 
 PC = 16'h0100;
 JALR_target = 16'h0160;
 instruction = 32'h0c4080e7;
 
 #10
 $display("jalr ra,196(ra)"); //not 196 a different value but for testing i didnt chagne
 print_state();
 
 instruction = 32'b0_000000_01011_01101_001_0000_0_1100011; //bne
 #10
 $display("bne a3,a1,0");
 print_state();
 
 instruction = 32'b0_000000_01011_01101_100_0000_0_1100011; //blt
 #10
 $display("blt a3,a1,0");
 print_state();
 
 instruction = 32'b0_000000_01011_01101_101_0000_0_1100011; //bge
 #10
 $display("blt a3,a1,0");
 print_state();
 
 instruction = 32'b0_000000_01011_01101_110_0000_0_1100011; //bltu
 #10
 $display("bltu a3,a1,0");
 print_state();
 
 instruction = 32'b0_000000_01011_01101_111_0000_0_1100011; //bgeu
 #10
 $display("bgeu a3,a1,0");
 print_state();
 
 instruction = 32'b00000000000000000110_01101_0110111; //LUI
 #10
 $display("lui a3,6");
 print_state();
 
 instruction = 32'b00000000000000000110_01101_0010111; //AUIPC
 #10
 $display("auipc a3,6");
 print_state();
 
 instruction = 32'b000000000000_01011_010_01101_0010011; //SLTI
 #10
 $display("SLTI a1,a3,0");
 print_state();
 
 instruction = 32'b000000000000_01011_011_01101_0010011; //SLTIU
 #10
 $display("SLTIU a1,a3,0");
 print_state();
 
 instruction = 32'b000000000011_01101_001_01011_0010011; //SLLI
 #10
 $display("SLLI a1,a3,3");
 print_state();
 
 instruction = 32'b000000000011_01101_101_01011_0010011; //SRLI
 #10
 $display("SRLI a1,a3,3");
 print_state();
 
 instruction = 32'b010000000011_01101_101_01011_0010011; //SRAI
 #10
 $display("SRAI a1,a3,3");
 print_state();
 
 #10
 $stop();
end

endmodule
