module simple_top( slave_fpga_clk, slave_reset,slave_data_out, slave_data, mast_start_bit, fpga_clk, mast_rd_wr, mast_address, mast_data, mast_rst, data_from_slave);

input slave_fpga_clk, mast_rst, slave_reset;

input [7:0] slave_data;

input mast_start_bit, fpga_clk, mast_rd_wr;
 input [7:0] mast_data;

input [6:0] mast_address;

output [7:0] slave_data_out;

output [7:0] data_from_slave;

wire scl_clock;

wire scl;


wire sda;

master_scl_generator ms1(fpga_clk, scl_clock); //instantiate scl generator which

//generate 100khz frequency

simple_slave_top ss1(.slave_fpga_clk(slave_fpga_cik), .slave_reset(slave_reset),

.slave_scl_input(scl),

.slave_sda_input(sda),

.slave_data_out(slave_data_out), .slave_data(slave_data));

//instantiation of slave module

simple_master sm1(.mast_start_bit(mast_start_bit), .fpga_clk(scl_clock), .mast_rd_wr(mast_rd_wr), .mast_address(mast_address), .mast_data(mast_data), .mast_rst(mast_rst) , .scl(scl),

.sda(sda), .data_from_slave(data_from_slave));

//instantiation of master module

endmodule

