// Master SCL generator to generate 100KHz SCL
module master_scl_generator(
    fpga_clock,
    scl_clock
);
    input fpga_clock;
    output scl_clock;
    integer count = 0;

    always @(posedge fpga_clock)
        if (count < 500)
            count <= count + 1;
        else
            count <= 1;

    assign scl_clock = (count < 251) ? 0 : 1;
endmodule

// SCL buffer to control SCL transmission
module scl_buf(
    mast_scl_en,
    master_scl,
    mast_scl_out
);
    input mast_scl_en;
    input master_scl;
    output mast_scl_out;

    bufif1 b111(mast_scl_out, master_scl, mast_scl_en);
endmodule