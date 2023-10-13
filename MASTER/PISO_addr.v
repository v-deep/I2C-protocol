// Code for PISO register to transfer address serially from master to slave
module mast_piso_addr(
    master_rd_wr,
    master_address,
    master_load_addr,
    master_shift_addr,
    master_scl_sixt,
    master_serial_out_addr
);
    input master_rd_wr;
    input master_load_addr, master_shift_addr;
    input master_scl_sixt;
    input [6:0] master_address;
    output master_serial_out_addr;
    reg [7:0] master_temp_addr;

    always @(negedge master_scl_sixt)
        if (master_load_addr)
            master_temp_addr <= {master_address, master_rd_wr};
        else if (master_shift_addr)
            master_temp_addr <= {master_temp_addr[6:0], 1'b0};
        else
            master_temp_addr <= master_temp_addr;

    assign master_serial_out_addr = master_temp_addr[7];
endmodule