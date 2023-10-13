// code for fsm of slave starts here
module slave_fsm(fpga_clk, slave_tri_en, slave_shift_addr, slave_shift_piso, slave_load_piso, 
                   slave_shift_data, slave_ack_sel, slave_mux_sel, slave_scl_sixt,slave_ack, slave_start_bit,
                      slave_addr_rcvd, slave_rd_wr, slave_reset);

input slave_scl_sixt, slave_reset, fpga_clk; // ye fpga clk faltu ka signal h
input slave_ack, slave_start_bit;
input slave_rd_wr;
input [6:0] slave_addr_rcvd;
output reg slave_tri_en, slave_ack_sel, slave_mux_sel;
output reg slave_shift_piso, slave_load_piso;
output reg slave_shift_addr, slave_shift_data;
parameter slave_device_addr = 7'b 1111010; // ye address de diya h slave ko

parameter sdetect_start = 4'b0000, sstart = 4'b0001, saddress_detect = 4'b0010, sread_write = 4'b0011, ssend_data = 4'b0100,
            srecieve_data= 4'b0101, sack_send = 4'b0110, sack_rcvd = 4'b0111, sdetect_stop = 4'b1000;

reg [3:0] s_state;
reg [3:0] s_next_state;
reg go_slave;
integer slave_count;
reg slave_check;

always@(negedge slave_scl_sixt, negedge slave_reset)
if(!slave_reset) begin
slave_count <= 1;
s_state<= sdetect_start;
end
else if (go_slave)
slave_count <= slave_count +1;
else 
slave_count <= 1;

always@(slave_ack, s_state, slave_start_bit, slave_rd_wr, slave_addr_rcvd)
case(s_state)
sdetect_start: s_next_state = (!slave_start_bit) ? sstart : sdetect_start;// o detech hua h toh start state m chla jaye 

sstart:
 s_next_state = saddress_detect;
saddress_detect : begin
go_slave = (slave_count == 8) ? 0:1;
s_next_state = (slave_count ==8 ) ? sread_write : saddress_detect;
end

sread_write :
s_next_state = (slave_addr_rcvd == slave_device_addr) ? (slave_rd_wr ? ssend_data : srecieve_data): (slave_rd_wr ? sdetect_start : sdetect_start);
// if address match hi nhi hua toh it goes to ideal state
ssend_data:begin
go_slave = (slave_count == 8)?  0:1; // send date jayega from PISO
s_next_state = (slave_count ==8 )? sack_send: ssend_data;
end

srecieve_data : begin
go_slave = (slave_count == 8)? 0:1;
s_next_state = (slave_count == 8)? sack_rcvd : srecieve_data;

end

sack_send:// yha pe slave ko recieve milegi toh if nhi mili toh go back toh ideal state
s_next_state = slave_ack ? sdetect_start : sdetect_stop;

sack_rcvd:// yha pe slave ne bheji h
s_next_state = sdetect_stop;// yha toh hum hi bhej rhe h toh stop state direct

sdetect_stop :
begin
s_next_state = sdetect_start;
slave_count = 1;
end
endcase

always@(negedge slave_scl_sixt, negedge slave_reset)
if(!slave_reset)
s_state = sdetect_start;
else 
s_state <= s_next_state;

always@(s_state, slave_rd_wr)
if (s_state == sdetect_start)
begin
slave_tri_en = 1;
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end

else if (s_state == saddress_detect)
begin
slave_tri_en = 1;// add. detect state pe bhi udhar se hi aana h toh tri en = 1
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 1;
end

else if (s_state == sread_write)
begin
slave_tri_en = 0;
slave_ack_sel = (slave_addr_rcvd== slave_device_addr); // ye mealy ban gya kyuki state depend on both input(jo address master se mil rha h ) and state, 
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = slave_rd_wr ? 1:0;// tab data bhejna h tabhi load kare
slave_shift_data = 0;
slave_shift_addr = 0;
end

else if (s_state == ssend_data)
begin
slave_tri_en = 0;
slave_ack_sel = 0;
slave_mux_sel = 1; // 1 pe data jayega aur 0 pe acknowledgement
slave_shift_piso = 1;// kyuki data jayega
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end


else if (s_state == srecieve_data)
begin
slave_tri_en = 1;
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 1; // kyuki hum SIPO m dalege dats
slave_shift_addr = 0;
end

else if (s_state == sack_send)// matlab data send ke liye ack. jo mila h i.e. it is ack. from master
begin// ye ack directly jayegi FSM m
slave_tri_en = 1;
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end

else if (s_state == sack_rcvd)
begin
slave_tri_en = 0;
slave_ack_sel = 1;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end


else if (s_state == sdetect_stop)
begin
slave_tri_en = 1;// kyuki stop toh udhar se hi aayega na
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end

else // means errorneous state means kisi state ki value se match na kar rha ho
begin
slave_tri_en = 1;
slave_ack_sel = 0;
slave_mux_sel = 0;
slave_shift_piso = 0;
slave_load_piso = 0;
slave_shift_data = 0;
slave_shift_addr = 0;
end

endmodule

// code for FSM slave ends here