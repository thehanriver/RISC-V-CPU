// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: ALU Test Bench

module ALU_tb();
reg branch_op;
reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;
wire branch;

ALU dut (
  .branch_op(branch_op),
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result),
  .branch(branch)
);

initial begin
  branch_op = 1'b0;
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #10
  $display("ALU Result 4 + 5: %d",result);
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU Result 4 < 5: %d",result);
  #10
  opB = 32'hffffffff;
  #10
  $display("ALU Result 4 < -1: %d",result);

  branch_op = 1'b1;
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b010_000; // BEQ
  #10
  $display("ALU Result (BEQ): %d",result);
  $display("Branch (should be 1): %b", branch);

/******************************************************************************
*                      Add Test Cases Here

    6'b011111: //JAL
        ALU_result <= operand_A;
    6'b111111: //JALR
        ALU_result <= operand_A;
    6'b010000://BEQ done
        ALU_result <= (operand_A==operand_B)? 32'b1:32'b0;
    6'b010001: //BNE
        ALU_result <= (operand_A!=operand_B)? 32'b1:32'b0;
    6'b010110: //BLTU done 
        ALU_result <= (operand_A<operand_B)? 32'b1:32'b0;
    6'b010101: //BGE done
        ALU_result <= ($signed(operand_A)>=$signed(operand_B))? 32'b1:32'b0;
    6'b010100: //BLT done
        ALU_result <= ($signed(operand_A)<$signed(operand_B))? 32'b1:32'b0;
    6'b010111://BGEU done 
        ALU_result <= (operand_A>=operand_B)? 32'b1:32'b0;
    6'b000011: //SLTIU,SLTU done
        ALU_result <= (operand_A<operand_B)? 32'b1:32'b0;

******************************************************************************/
  #10
    ctrl = 6'b000011;  //SLTIU,SLTU
    opA = 4;
    opB = 5; 
  #10
    $display("ALU Result 4 < 5: %d",result);
  #10
    ctrl = 6'b001000;   //SUB
  #10
    $display("ALU Result 4-5: %b", result);
  #10
    opA = 5;
    opB = 4;
  #10  
    $display("ALU Result 5-4: %b", result);
  #10
    opA = 32'hffffffff;
  #10
    $display("ALU Result -1-4: %b",result);
  #10 
    opB = 32'hffffffff;
  #10
    $display("ALU Result -1-(-1): %b", result);
  #10
    opA = 5;
  #10 
    $display("ALU Result 5-(-1): %b", result);
  #10
   
    opA = 32'hffffffff;
    opB = 2;
    ctrl = 6'b001101; //SRA,SRAI
  #10 
    $display("ALU Result opA >>> opB: opA = %d; opB = %d: result = %b",opA,opB,result); 
  #10
    ctrl = 6'b000101; //SRL,SRLI
  #10
     $display("ALU Result opA >> opB: opA = %d; opB = %d: result = %b",opA,opB,result); 
  #10
    ctrl = 6'b000001; //SLL, SLLI
  #10 
    $display("ALU Result opA << opB: opA = %d; opB = %d: result = %b",opA,opB,result); 
  #10
    ctrl = 6'b000111; //AND, ANDI
    opA = 1;
    opB = 1;
  #10
    $display("ALU Result 1 and 1: result = %d",result);
  #10
    ctrl =  6'b000110; //ORI, OR
  #10
    $display("ALU Result 1 or 1: result = %d",result);
  #10
    ctrl = 6'b000100; //XORI 
  #10
    $display("ALU Result 1 xor 1: result = %d",result);
  #10
    opB = 0;
    ctrl = 6'b000111; //AND, ANDI
  #10
    $display("ALU Result 1 and 0: result = %d",result);
  #10
    ctrl =  6'b000110; //ORI, OR
  #10
    $display("ALU Result 1 or 0: result = %d",result);
  #10
    ctrl = 6'b000100; //XORI 
  #10
    $display("ALU Result 1 xor 0: result = %d",result);
  #10
    opA = 5;
    opB = 5;
  #10
    ctrl =  6'b000110; //ORI, OR
  #10
    $display("ALU Result 5 ori 5: result = %d", result);
  #10
    ctrl = 6'b000100; //XORI
  #10
    $display("ALU Result 5 xor 5: result = %d",result);
  #10
    ctrl = 6'b000111; //AND, ANDI
  #10
    $display("ALU Result 5 andi 5: result = %d", result);  
  #10
    ctrl =  6'b000110; //ORI, OR
    opB = 4;
  #10
     $display("ALU Result 5 ori 4: result = %d", result);
  #10
     ctrl = 6'b000100; //XORI
  #10 
     $display("ALU Result 5 xori 4: result = %d", result);
  #10
    ctrl = 6'b000111; //AND, ANDI
  #10
     $display("ALU Result 5 andi 4: result = %d", result);
  #10
    ctrl = 6'b010111;//BGEU
  #10
    $display("ALU Result 5 >= 4: result = %d", result);
  #10
    opB = 5;
  #10
    $display("ALU Result 5 >= 5: result = %d", result);
  #10
    ctrl = 6'b010101; //BGE
    opB = 32'hffffffff;
  #10
    $display("ALU Result 5 >= -1: result = %d", result);
  #10
    ctrl = 6'b010001; //BNE
  #10
    $display("ALU Result 5 != -1: result = %d", result);
  #10
    ctrl = 6'b111111; //JALR
  #10 
    $display("ALU Result 5 jalr -1: result = %d", result);
  #10
    ctrl = 6'b011111; //JALR
  #10
    $display("ALU Result 5 jal -1: result = %d", result);
  #10
  $stop();


end

endmodule