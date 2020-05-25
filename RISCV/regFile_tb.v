// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: Register File Test Bench

module regFile_tb();

reg clock, reset;
reg wEn;
reg [4:0] read_sel1;
reg [4:0] read_sel2;
reg [4:0] write_sel;
reg [31:0] write_data;
wire [31:0] read_data1;
wire [31:0] read_data2;
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// Fill in port connections
regFile uut (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2));


always #5 clock = ~clock;

initial begin
  clock = 1'b1;
  reset = 1'b1;
  wEn = 1'b0;

  #20;
  reset = 1'b0;
  read_sel1 = 5'b00100;
  read_sel2 = 5'b01000;
  
  #20
  wEn = 1;
  write_data = 32'haaaaaaaa;
  write_sel = 5'b00000;
 
  #20
  write_sel = 5'b00100;
   
  #20
  write_data = 32'hbbbbbbbb;
//  write_sel = 5'b00001;
  #20
  wEn = 0;
  write_data = 32'hffffffff;
  write_sel = 5'b01000;
  // Test reads and writes to the register file here
end
endmodule
