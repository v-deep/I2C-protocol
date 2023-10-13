// Code for PISO register to transfer data serially from master to slave
module mast_piso_data(
    master_data,
    master_scl_sixt,
    master_load_data,
    master_shift_data,
    master_serial_out_data
);
    input [7:0] master_data;
    input master_load_data, master_shift_data;
    input master_scl_sixt;
    output master_serial_out_data;
    reg [7:0] master_temp_data;

    always @(negedge master_scl_sixt)
        if (master_load_data)
            master_temp_data <= master_data;
        else if (master_shift_data)
            master_temp_data <= {master_temp_data[6:0], 1'b0};
        else
            master_temp_data <= master_temp_data;

    assign master_serial_out_data = master_temp_data[7];
endmodule