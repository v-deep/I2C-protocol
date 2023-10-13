// tri-state logic of slave
module slave_tristate_logic(slave_sda_out, slave_sda, slave_sda_in, slave_tri_en);
input slave_tri_en, slave_sda_out;
input slave_sda;
output slave_sda_in;

bufif0 b1(slave_sda, slave_sda_out, slave_tri_en);
buf b2(slave_sda_in, slave_sda);
endmodule
