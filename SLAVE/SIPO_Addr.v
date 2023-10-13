// sipo reg. for recieving addr. from master

module slave_sipo_addr(slave_serial_in, slave_scl_sixt, slave_rec_addr_shift, slave_addr_out, slave_rd_wr);
input slave_serial_in, slave_rec_addr_shift;
input slave_scl_sixt;

output [6:0] slave_addr_out; 
output slave_rd_wr;
reg [7:0] slave_temp_addr;

always@(posedge slave_scl_sixt)
if (slave_rec_addr_shift)
slave_temp_addr <= {slave_temp_addr[6:0], slave_serial_in};// toh es order m chije enter karegi in SIPO
else
slave_temp_addr <=slave_temp_addr;
assign slave_addr_out = slave_temp_addr[7:1]; // pheli 7 bit belong to address
assign slave_rd_wr = slave_temp_addr[0]; // 0th position wali rd/wr ban jayegi

endmodule