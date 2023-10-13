// piso reg for sending data from slave to master
module slave_piso_data(slave_data, slave_scl_sixt, slave_load_data, slave_shift_data, slave_serial_out_data);
input [7:0] slave_data;// input 8 bit ka hoga esme
input slave_load_data, slave_shift_data, slave_scl_sixt;
output slave_serial_out_data;

reg[7:0] slave_temp_data;

// piso reg for transfer data

always@(negedge slave_scl_sixt) // works at negative edge
if (slave_load_data)
slave_temp_data <= slave_data;

else if (slave_shift_data)
slave_temp_data <= {slave_temp_data[6:0], 1'b0};// left shift hoga kyuki MSB pheli jayegi whereas in UART m right shift hogi
else 
slave_temp_data <= slave_temp_data;

assign slave_serial_out_data = slave_temp_data[7];
endmodule