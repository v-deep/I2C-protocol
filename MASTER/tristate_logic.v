// TRISTATE Logic for Master
module mast_tristate_logic(
    master_sda_out,
    master_tri_en,
    master_sda_in,
    master_sda
);
    // port declaration //
    input master_tri_en, master_sda_out;
    inout master_sda;
    output master_sda_in;

    bufif0 b1(master_sda, master_sda_out, master_tri_en);
    buf b2(master_sda_in, master_sda);
endmodule