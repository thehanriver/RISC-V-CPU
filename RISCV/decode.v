// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: Decode Module

module decode #(
  parameter ADDRESS_BITS = 16
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC,
  input [31:0] instruction,

  // Inputs from Execute/ALU
  input [ADDRESS_BITS-1:0] JALR_target,
  input branch,

  // Outputs to Fetch
  output next_PC_select,
  output [ADDRESS_BITS-1:0] target_PC,

  // Outputs to Reg File
  output [4:0] read_sel1,
  output [4:0] read_sel2,
  output [4:0] write_sel,
  output wEn,

  // Outputs to Execute/ALU
  output branch_op, // Tells ALU if this is a branch instruction
  output [31:0] imm32,
  output [1:0] op_A_sel,
  output op_B_sel,
  output [5:0] ALU_Control,

  // Outputs to Memory
  output mem_wEn,

  // Outputs to Writeback
  output wb_sel

);

localparam [6:0]R_TYPE  = 7'b0110011, // {2'b0 , instr[30]}
                I_TYPE  = 7'b0010011, // {2'b0 , instr[30]}
                STORE   = 7'b0100011, //
                LOAD    = 7'b0000011, //
                BRANCH  = 7'b1100011, // 3'b010
                JALR    = 7'b1100111, // 6'b111111
                JAL     = 7'b1101111, // 6'b011111
                AUIPC   = 7'b0010111, //
                LUI     = 7'b0110111; //


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.
wire[6:0]  s_imm_msb;
wire[4:0]  s_imm_lsb;
wire[19:0] u_imm;
wire[11:0] i_imm_orig;
wire[19:0] uj_imm;
wire[11:0] s_imm_orig;
wire[12:0] sb_imm_orig;

wire[31:0] sb_imm_32;
wire[31:0] u_imm_32;
wire[31:0] i_imm_32;
wire[31:0] s_imm_32;
wire[31:0] uj_imm_32;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target;
wire [ADDRESS_BITS-1:0] JAL_target;


// Read registers
assign read_sel2  = instruction[24:20];
assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
/*
 // Inputs from Fetch
     input [ADDRESS_BITS-1:0] PC,
     input [31:0] instruction,
   
     // Inputs from Execute/ALU
     input [ADDRESS_BITS-1:0] JALR_target,
     input branch,

DO ON SUNDAY
output [1:0] op_A_sel,
output op_B_sel,


output [5:0] ALU_Control, done 
output [31:0] imm32, done 
output wEn, done
output branch_op,done // Tells ALU if this is a branch instruction 
output mem_wEn,done 
output wb_sel done
output [ADDRESS_BITS-1:0] target_PC, done 
*/

/*
R_TYPE  = 7'b0110011, // {2'b0 , instr[30]}{2'b00,instruction[30]}
I_TYPE  = 7'b0010011, // {2'b0 , instr[30]}
STORE   = 7'b0100011, //
LOAD    = 7'b0000011, //
BRANCH  = 7'b1100011, // 3'b010 {3'b010,funct3}
JALR    = 7'b1100111, // 6'b111111
JAL     = 7'b1101111, // 6'b011111
AUIPC   = 7'b0010111, //
LUI     = 7'b0110111; //
*/


    
    
// assign VAR = (COND) ? TRUE : FALSE;opcode == JALR) ? 2'b10 :
// assign VAR = (COND) ? TRUE : (== Branch) ? (Res) : ();opcode == JALR

assign op_B_sel = (opcode == R_TYPE || opcode == BRANCH) ? 1'b0 : 1'b1;
assign op_A_sel =  (opcode == JAL||opcode == JALR) ? 2'b10 : (opcode == AUIPC) ? 2'b01 : 2'b00;
assign next_PC_select = (branch || opcode == JALR || opcode == JAL)? 1'b1 : 1'b0;

assign ALU_Control = (opcode == AUIPC || opcode == LUI || opcode == LOAD || opcode == STORE) ? 6'b000000 : (opcode == JAL) 
    ? 6'b011111 : (opcode ==JALR) 
    ? 6'b111111 : (opcode==BRANCH) 
    ? {3'b010,funct3} : (funct3 ==  3'b001 || funct3 == 3'b101 || funct7 == 7'b0100000)
    ? {2'b00,instruction[30],funct3}: {3'b000,funct3} ;
    
assign wb_sel = (opcode == LOAD)? 1'b1 :1'b0;
assign wEn = (opcode == I_TYPE || opcode == R_TYPE || opcode == LOAD || opcode == JALR || opcode == JAL || opcode == AUIPC || opcode == LUI)? 1'b1 :1'b0;
assign mem_wEn = (opcode == STORE )? 1'b1 :1'b0;
assign branch_op = ( opcode == BRANCH)? 1'b1 :1'b0;

assign uj_imm = {instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
assign uj_imm_32 = $signed(uj_imm);

assign sb_imm_orig = {instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0};
assign sb_imm_32 = $signed(sb_imm_orig);
//explicit sign extend
assign s_imm_msb = instruction[31:25];
assign s_imm_lsb = instruction[11:7];
assign s_imm_orig = {s_imm_msb,s_imm_lsb};
assign s_imm_32 = $signed( s_imm_orig);

assign u_imm = instruction[31:12];
assign u_imm_32 = $signed({instruction[31:12],12'b0});

assign i_imm_orig = instruction[31:20];
assign i_imm_32 = $signed(instruction[31:20]);


assign imm32 = (opcode == I_TYPE||opcode == JALR||opcode==LOAD) ? i_imm_32: (opcode == LUI || opcode == AUIPC) 
    ? u_imm_32 : (opcode == JAL)
    ? uj_imm_32 : (opcode == BRANCH) 
    ? sb_imm_32: (opcode == STORE)
    ? s_imm_32: 32'b0;

assign JAL_target = PC + $signed(uj_imm_32);
assign branch_target = PC +sb_imm_32;

assign target_PC = (opcode == JAL)? JAL_target : 
(opcode == JALR) ? ((JALR_target + i_imm_32) & 16'b1111111111111110):
(opcode == BRANCH)? (branch_target) : 
16'b0; 
 

//if (opcode == JALR)
//begin
//    op_A_sel <= 2'b10;
//end
//else if (opcode == JAL)
//begin
//    op_A_sel <= 2'b10;
//end    
//else if (opcode == AUIPC)
//begin
//    op_A_sel <= 2'b01;
//end
//else
//begin
//    op_A_sel <= 2'b00;
//end

//if (opcode == AUIPC || opcode == LUI || opcode == LOAD || opcode == STORE)
//begin
//    ALU_Control <= 6'b000000;
//end
//else if(opcode == JAL)
//begin
//    ALU_Control <= 6'b011111;
//end
//else if(opcode == JALR)begin
//    ALU_Control <= 6'b111111;end
//else if (opcode == BRANCH)begin
//    ALU_Control <= {3'b010,func3};end
//else
//begin
//    ALU_Control <= {2'b00,instr[30]};
//end


//begin
//if ()
//~~~ <= value

//end


/*
if(opcode == R_TYPE || opcode == LOAD)
begin
     wb_sel <= 1'b1;
     wEn <= 1'b1;
end
else
begin
     wb_sel <= 1'b0;
     wEn <= 1'b0;
end
*/

/*
if(opcode == LOAD || opcode == STORE)
    begin mem_wEn <= 1'b1; end
else
     begin mem_wEn <= 1'b0; end
*/

/*
if( opcode == BRANCH) begin
    branch_op <= 1'b1;end
else
begin
   branch_op <= 1'b0; end
 */
 /*
if(opcode == I-TYPE||opcode == JALR||opcode==LOAD)
    begin imm32 <= $signed(instruction[31:20]); end
else if(opcode == LUI || AUIPC)
    begin imm32 <= $signed({instruction[31:12],12'b0}); end
else if(opcode == JAL)
    begin imm32 <= $signed({instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}); end
else if(opcode == BRANCH)
    begin imm32 <= $signed({instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0});    end
else if(opcode == STORE)begin
     imm32 <= $signed({instruction[31:25],instruction[11:7]}); end
else
    begin
    imm32 <= 32'b0; end
 
    wire[6:0]  s_imm_msb; ok
    wire[4:0]  s_imm_lsb; ok
    wire[19:0] u_imm; ok
    wire[11:0] i_imm_orig; ok
    wire[19:0] uj_imm; ok
    wire[11:0] s_imm_orig; ?
    wire[12:0] sb_imm_orig;
    
    wire[31:0] sb_imm_32;
    wire[31:0] u_imm_32; ok
    wire[31:0] i_imm_32; ok
    wire[31:0] s_imm_32; ok
    wire[31:0] uj_imm_32;ok
    
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [1:0] extend_sel;


*/

/*if asidjoasdj
    if asdjk
 else if
 
//if JAL JALR or BRANCH if branch taken PC +4 it not branch taken PC 
if (opcode == JAL) begin
    target_PC <= PC + $signed({instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}); end
else if(opcode == JALR) begin
    target_PC <= (JALR_target) & ~(2'h01); end
else if (opcode == BRANCH) begin
     target_PC <= branch ? PC + $signed({instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0}):PC + 4;
      end
else
    begin
     target_PC <= ADDRESS_BITS-1'b0;
  end
 */
endmodule
