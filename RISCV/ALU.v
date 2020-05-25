// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: ALU

module ALU (
  input branch_op,
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  output [31:0] ALU_result,
  output branch
);

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/    

assign branch = (branch_op == 1'b1 && ALU_result == 32'b1)? 1'b1:1'b0;
assign ALU_result = (ALU_Control == 6'b011111)? operand_A: //JAL
    (ALU_Control == 6'b111111)? operand_A: //JALR
    (ALU_Control == 6'b010000)? (($signed(operand_A)== $signed(operand_B))? 32'b1:32'b0): //BEQ
    (ALU_Control == 6'b010001)? (($signed(operand_A)!=$signed(operand_B))? 32'b1:32'b0): //BNE
    (ALU_Control == 6'b010110)? ((operand_A<operand_B)? 32'b1:32'b0): // BLTU
    (ALU_Control == 6'b010101)? (($signed(operand_A)>=$signed(operand_B))? 32'b1:32'b0): //BGE
    (ALU_Control == 6'b010100)? ( ($signed(operand_A)< $signed(operand_B) )? 32'b1:32'b0): //BLT
    (ALU_Control == 6'b010111)? ((operand_A>=operand_B)? 32'b1:32'b0): //BGEU
    (ALU_Control == 6'b000011)? ((operand_A<operand_B)? 32'b1:32'b0): //SLTIU,SLTU
    (ALU_Control == 6'b000010)? (($signed(operand_A)<$signed(operand_B))? 32'b1:32'b0): //SLTI,SLT
    (ALU_Control == 6'b000100)? (operand_A ^ operand_B): //XOR
    (ALU_Control == 6'b000110)? (operand_A | operand_B): //ORI, OR
    (ALU_Control == 6'b000111)? (operand_A & operand_B): //AND,ANDI
    (ALU_Control == 6'b000001)? (operand_A << operand_B): //SLL,SLLI
    (ALU_Control == 6'b000101)? (operand_A >> operand_B): //SRL,SRLI
    (ALU_Control == 6'b001101)? ($signed($signed(operand_A)>>>operand_B)): //SRA,SRAI
    (ALU_Control == 6'b001000)? ($signed(operand_A) - $signed(operand_B)): //SUB
    operand_A +operand_B; //LUI,AUIPC,LW,SW,ADDI,ADD
    
    
    

/*
works but frowned upon cause ANY signal triggers it due to *
always @(*)
begin
    branch <= branch_op;
    case(ALU_Control)
    6'b000000: //LUI,AUIPC,LW,SW,ADDI,ADD done
        ALU_result <= operand_A + operand_B;
    6'b011111: //JAL done
        ALU_result <= operand_A;
    6'b111111: //JALR done
        ALU_result <= operand_A;
    6'b010000://BEQ done
        ALU_result <= (operand_A==operand_B)? 32'b1:32'b0;
    6'b010001: //BNE done
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
    6'b000010: //SLTI,SLT done
        ALU_result <= ($signed(operand_A)<$signed(operand_B))? 32'b1:32'b0;
    6'b000100: //XORI 
        ALU_result <= (operand_A ^ operand_B);
    6'b000110: //ORI, OR
        ALU_result <= (operand_A | operand_B);
    6'b000111: //AND, ANDI
        ALU_result <= (operand_A & operand_B);
    6'b000001: //SLL, SLLI
        ALU_result <= operand_A << operand_B;
    6'b000101: //SRL,SRLI
        ALU_result <= operand_A >> operand_B;
    6'b001101: //SRAI, SRA
        ALU_result <= $signed(operand_A) >>> $signed(operand_B);
    6'b001000: //SUB
        ALU_result <= $signed(operand_A) - $signed(operand_B);
     endcase 
  end
  */     
endmodule
