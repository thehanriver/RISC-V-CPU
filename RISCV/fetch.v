// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: Fetch Module

module fetch #(
  parameter ADDRESS_BITS = 16
) (
  input  clock,
  input  reset,
  input  next_PC_select,
  input  [ADDRESS_BITS-1:0] target_PC,
  output [ADDRESS_BITS-1:0] PC
);

reg [ADDRESS_BITS-1:0] PC_reg;

assign PC = PC_reg;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/


always @(posedge clock or posedge reset)
begin

if(reset)
    begin
    PC_reg <= 16'b0;
    end
else
    begin
    PC_reg <= (next_PC_select == 1'b1)? target_PC : (PC_reg + 4);
    end
end
endmodule
