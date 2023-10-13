// testbench
module simple_top_tb();

reg slave_fpga_clk=0;
 reg mast_rst, slave_reset; 
reg [7:0]slave_data; 
reg mast_start_bit, mast_rd_wr ;
reg fpga_clk=0; 
reg [7:0]mast_data; 
reg [6:0]mast_address ;
wire [7:0] slave_data_out; 
wire [7:0] data_from_slave;

simple_top sit(slave_fpga_clk, slave_reset,slave_data_out, slave_data ,mast_start_bit, fpga_clk, mast_rd_wr, mast_address, mast_data, mast_rst, data_from_slave); 
//instantiation of 12c design module in testbench

initial

forever #4 slave_fpga_clk = ~slave_fpga_clk;
initial forever #10 fpga_clk = ~fpga_clk;

initial

begin

mast_rst=0; slave_reset=0;mast_start_bit=1; #4500 mast_rst = 1; slave_reset=1;

#180000 mast_start_bit=0;

end

initial begin
mast_address = 7'b1111010; mast_rd_wr=0; slave_data= 8'b1001_1110; 
mast_data=8'b1111010;

end

endmodule
