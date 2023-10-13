// mux at slave side to control output of slave

module slave_mux(slave_mux_sel, slave_serial_out_data,slave_mux_out, slave_acknowledge);
 input slave_mux_sel, slave_serial_out_data, slave_acknowledge;
output reg slave_mux_out;

always@(slave_mux_sel, slave_acknowledge, slave_serial_out_data)
if(slave_mux_sel)
slave_mux_out = slave_serial_out_data;
else
slave_mux_out = slave_acknowledge;
endmodule