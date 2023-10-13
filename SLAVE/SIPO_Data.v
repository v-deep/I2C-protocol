// sipo reg. for recieving data from master
module slave_sipo_data(slave_serial_in, slave_scl_sixt, slave_rec_data_shift, slave_data_out);
input slave_serial_in, slave_rec_data_shift;// 1 bit ka input hooga
input slave_scl_sixt;

output [7:0] slave_data_out;
reg [7:0] slave_temp_data;

always@(posedge slave_scl_sixt)
if (slave_rec_data_shift)
slave_temp_data <= {slave_temp_data[6:0], slave_serial_in}; // left shift hoga
else
slave_temp_data <=slave_temp_data;
assign slave_data_out = slave_temp_data;

endmodule
