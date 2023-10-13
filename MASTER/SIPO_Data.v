// Code for SIPO register to receive data from slave
module mast_sipo_slave_data(
    master_serial_in,
    master_scl_sixt,
    master_rec_data_shift,
    master_data_out
);
    input master_serial_in, master_rec_data_shift;
    input master_scl_sixt;
    output [7:0] master_data_out;
    reg [7:0] master_temp_received;

    always @(posedge master_scl_sixt)
        if (master_rec_data_shift)
            master_temp_received <= {master_temp_received[6:0], master_serial_in};
        else
            master_temp_received <= master_temp_received;

    assign master_data_out = master_temp_received;
endmodule