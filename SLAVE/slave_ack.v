// mux for sending ack.
module slave_ack(slave_scl_sixt, slave_ack_sel, slave_ack_out);
input slave_ack_sel;
input slave_scl_sixt ;
output reg slave_ack_out;
parameter ack = 1'b0, nack = 1'b1;
// taki jab ack bhejna h toh 0 jaye aur nack jaye toh 1
always@(*)
if (slave_ack_sel)
slave_ack_out = ack;
else 
slave_ack_out = nack;
endmodule
