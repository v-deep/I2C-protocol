module simple_master(mast_start_bit, fpga_clk, mast_rd_wr, mast_address, mast_data, mast_rst, scl, sda, data_from_slave);
    input mast_start_bit, mast_rd_wr;
    input fpga_clk, mast_rst;
    input [6:0] mast_address;
    input [7:0] mast_data;
    output [7:0] data_from_slave;
    inout tri1 sda;
    output tri1 scl;
    wire mast_load_addr, mast_shift_addr, mast_serial_out_addr;
    wire mast_load_data, mast_shift_data, mast_serial_out_data, mast_shift_d_slave;
    wire mast_scl;
    wire mast_tri_en, mast_sda_in, mast_sda_out, mast_demux_select, mast_ack, mast_slavedata;
    
    wire master_scl_en, mast_ack_sel, mast_ack_out;
    wire [1:0] mast_mux_sel;
    wire [7:0] mast_data_out;

    // Instantiation of master FSM
    mast_fsm mfsm(
        .master_start_bit(mast_start_bit),
        .master_rd_wr(mast_rd_wr),
        .master_scl_sixt(fpga_clk),
        .master_rst(mast_rst),
        .master_ack(mast_ack),
        .master_load_add(mast_load_addr),
        .master_shift_add(mast_shift_addr),
        .master_load_data(mast_load_data),
        .master_shift_data(mast_shift_data),
        .master_mux_sel(mast_mux_sel),
        .master_tri_en(mast_tri_en),
        .master_demux_sel(mast_demux_select),
        .master_shift_d_slave(mast_shift_d_slave),
        .master_ack_sel(mast_ack_sel),
        .mast_scl_en(master_scl_en)
    );

    // Instantiation of demux to receive data from slave
    mast_demux mdmux(
        .master_demux_in(mast_sda_in),
        .master_demux_select(mast_demux_select),
        .master_ack(mast_ack),
        .master_slavedata(mast_slavedata)
    );

    // Instantiation of mux to create frame
    mast_mux mmux(
        .master_addrslave(mast_serial_out_addr),
        .master_dataslave(mast_serial_out_data),
        .select(mast_mux_sel),
        .master_mux_out(mast_sda_out),
        .master_ack_out(mast_ack_out)
    );

    // Instantiation of ACK_MUX to send acknowledgement
    mast_ack mack(
        .master_scl_sixt(fpga_clk),
        .master_ack_sel(mast_ack_sel),
        .master_ack_out(mast_ack_out)
    );

    // Instantiation of SIPO register to receive data from slave
    mast_sipo_slave_data mssd(
        .master_serial_in(mast_slavedata),
        .master_scl_sixt(fpga_clk),
        .master_rec_data_shift(mast_shift_d_slave),
        .master_data_out(mast_data_out)
    );

    // TRISTATE LOGIC OF MASTER
    mast_tristate_logic mtl(
        .master_sda_out(mast_sda_out),
        .master_tri_en(mast_tri_en),
        .master_sda_in(mast_sda_in),
        .master_sda(sda)
    );

    // PISO register to send data serially to slave
    mast_piso_data mpd(
        .master_data(mast_data),
        .master_scl_sixt(fpga_clk),
        .master_load_data(mast_load_data),
        .master_shift_data(mast_shift_data),
        .master_serial_out_data(mast_serial_out_data)
    );

    // PISO register to send address serially
    mast_piso_addr mpa(
        .master_rd_wr(mast_rd_wr),
        .master_address(mast_address),
        .master_load_addr(mast_load_addr),
        .master_shift_addr(mast_shift_addr),
        .master_scl_sixt(fpga_clk),
        .master_serial_out_addr(mast_serial_out_addr)
    );

    // Buffer to control scl
    scl_buf b12(
        .master_scl(fpga_clk),
        .mast_scl_out(mast_scl),
        .mast_scl_en(master_scl_en)
    );
    
    assign scl = mast_scl;
    assign data_from_slave = mast_data_out;
endmodule
