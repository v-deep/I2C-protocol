// top module starts here

module simple_slave_top(slave_fpga_clk, slave_reset, slave_scl_input, slave_sda_input, slave_data_out, slave_data);
input slave_fpga_clk, slave_reset;
input slave_scl_input;// scl

input [7:0] slave_data;// jo master se aayega data

output [7:0]slave_data_out;// output pe jo data aayega

inout slave_sda_input;// sda

wire start_stop_detect;

wire slave_sda_in, slave_tri_en;

wire slave_shift_data, slave_load_data;

wire slave_rec_data_shift;

wire slave_sda_out;

wire slave_ack_out, slave_serial_out_data,slave_ack_sel, slave_mux_sel;
wire slave_rec_addr_shift, slave_rd_wr; 
wire [6:0]slave_addr_out;


//instantiation of start-stop detector module slave start stop detector ssd1(slave_reset(slave_reset),
slave_start_stop_detector sssd( .slave_reset(slave_reset),
.slave_scl_in(slave_scl_input),

.slave_sda_in(slave_sda_input), .start_stop_detect(start_stop_detect));

//instantiation of tristate logic to control inout functionality of s slave tristate logic stil.slave_sda_out(slave sa out)
slave_tristate_logic stl(. slave_sda_out(slave_sda_out),
.slave_tri_en(slave_tri_en), .slave_sda_in(slave_sda_in),

.slave_sda(slave_sda_Input));

//MUX to send ACK when data or address received by slave slave_ack sal slave scl_sixt(slave_scl_input), slave_ack,sellslave k sel),

slave_ack sa(.slave_scl_sixt(slave_scl_input), .slave_ack_sel(slave_ack_sel) , .slave_ack_out(slave_ack_out));

//SIPO register to receive address from master

slave_sipo_addr ssa(.slave_serial_in(slave_sda_in), .slave_scl_sixt(slave_scl_input),

.slave_rec_addr_shift(slave_rec_addr_shift), .slave_addr_out(slave_addr_out) , .slave_rd_wr(slave_rd_wr));

//SIPO register to receive data from master

slave_sipo_data ssd(.slave_serial_in(slave_sda_in), .slave_scl_sixt(slave_scl_input), .slave_rec_data_shift(slave_rec_data_shift),

.slave_data_out(slave_data_out));

//PISO register to send data from slave to master 
slave_piso_data spd(.slave_data(slave_data), .slave_scl_sixt(slave_scl_input),

.slave_load_data(slave_load_data),

.slave_shift_data(slave_shift_data), .slave_serial_out_data(slave_serial_out_data));

//MUX at slave side to control output of slave 
slave_mux  sm(.slave_mux_sel(slave_mux_sel),

.slave_serial_out_data(slave_serial_out_data), .slave_mux_out(slave_sda_out), .slave_acknowledge(slave_ack_out));

//instantiation of FSM of slave 
slave_fsm sf1(.fpga_clk(slave_sel_input), .slave_tri_en(slave_tri_en),

.slave_shift_addr(slave_rec_addr_shift),

.slave_shift_piso( slave_shift_data), .slave_load_piso(slave_load_data),

.slave_shift_data(slave_rec_data_shift),

.slave_ack_sel(slave_ack_sel), .slave_mux_sel(slave_mux_sel), .slave_scl_sixt(slave_scl_input), .slave_ack(slave_sda_input),

.slave_start_bit(start_stop_detect), .slave_addr_rcvd(slave_addr_out), .slave_rd_wr(slave_rd_wr), .slave_reset(slave_reset));

endmodule
