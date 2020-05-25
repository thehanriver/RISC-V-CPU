// Name: Sarina Sabharwal, Mario Han
// BU ID: U83678891, U28464330
// EC413 Project: Register File 

module regFile (
  input clock,
  input reset,
  input wEn, // Write Enable
  input [31:0] write_data,
  input [4:0] read_sel1,
  input [4:0] read_sel2,
  input [4:0] write_sel,
  output [31:0] read_data1,
  output [31:0] read_data2
);

reg   [31:0] reg_file[0:31];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

integer i;


always @ (posedge clock or reset)
begin
    if(reset)
        begin 
            for (i=0; i <32; i = i + 1)
            begin
            reg_file[i] <= 32'b0; //0x = 0
            end
        end
    else 
        begin   
            if(wEn && write_sel != 5'b00000)
                begin
                    reg_file[write_sel] <= write_data;
                end
            else
                begin
                    reg_file[write_sel] <= reg_file[write_sel];
                    for(i=0; i<32; i = i+1)
                    begin
                        reg_file[i]<= reg_file[i];
                    end
                end
        end
end    

assign read_data1 = reg_file[read_sel1];
assign read_data2 = reg_file[read_sel2];

endmodule
