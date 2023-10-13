module slave_start_stop_detector ( slave_reset, slave_scl_in, slave_sda_in, start_stop_detect);
input slave_reset;
input slave_scl_in, slave_sda_in;
output start_stop_detect;
wire rst_clock;
wire t, s1, s2;

// instantiation of toggle register
slave_toggle_register str1(.slave_out (t), . slave_load(slave_scl_in), .slave_rst(slave_reset), .slave_clock(rst_clock));

// instantiation of reg1 works at negedge of sda
slave_reg_pos srp1(.pslave_out(s1), .pslave_in(t), .pslave_clock(rst_clock), .pslave_rst(slave_reset), .pslave_load(slave_scl_in));


// instantiation of reg2 works at negedge of sda
slave_reg_neg srnn1(.nslave_out(s2), .nslave_in(t), .nslave_clock(rst_clock), .nslave_rst(slave_reset), .nslave_load(slave_scl_in));

assign rst_clock = slave_sda_in;
assign start_stop_detect = ~(s1^s2);

endmodule

module slave_toggle_register(slave_out, slave_load, slave_rst, slave_clock);
input slave_load;
input slave_rst, slave_clock;
output slave_out;
reg q;

always@(posedge slave_clock, negedge slave_rst)
begin
if(!slave_rst) begin
q <= 1'b1;
end
else if(slave_load)
begin
q <= !q;
end
end
assign slave_out = q;

endmodule

module slave_reg_neg (nslave_out, nslave_in, nslave_clock,  nslave_load,  nslave_rst);
input  nslave_clock,  nslave_rst;
input  nslave_in,  nslave_load;
output  nslave_out;
 reg q;

always@(negedge nslave_clock, negedge  nslave_rst)
if (!nslave_rst)
q <= 1'b0;
else if (nslave_load)
q <= nslave_in;
else q <= q;

assign  nslave_out = q;

endmodule

module slave_reg_pos(pslave_out, pslave_in, pslave_clock,  pslave_load,  pslave_rst);
input  pslave_load,  pslave_clock,  pslave_rst,  pslave_in;
output  pslave_out;
reg q;
 
always@(posedge  pslave_clock, negedge  pslave_rst)
if(! pslave_rst)
q <= 1'b0;
else if ( pslave_load)
q <= pslave_in;
else q <= q;

assign pslave_out = q;

endmodule

// code for start-stop detector ends here
