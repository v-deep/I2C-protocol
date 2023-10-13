// Code for demux to receive data and ACK from slave
module mast_demux(
    master_demux_in,
    master_demux_select,
    master_ack,
    master_slavedata
);
    input master_demux_in, master_demux_select;
    output reg master_ack, master_slavedata;

    always @(master_demux_in, master_demux_select)
        case (master_demux_select)
            1'b0:
                begin
                    master_ack = master_demux_in;
                    master_slavedata = 1'b0;
                end
            1'b1:
                begin
                    master_ack = 1'b0;
                    master_slavedata = master_demux_in;
                end
        endcase
endmodule

// Code Master 4 by 1 mux for making frame
module mast_mux(
    master_addrslave,
    master_dataslave,
    select,
    master_mux_out,
    master_ack_out
);
    input master_addrslave, master_dataslave, master_ack_out;
    input [1:0] select;
    output reg master_mux_out;

    always @(select, master_addrslave, master_dataslave, master_ack_out)
        case (select)
            2'b00:
                master_mux_out = 1'b0;
            2'b01:
                master_mux_out = master_addrslave;
            2'b10:
                master_mux_out = master_dataslave;
            2'b11:
                master_mux_out = master_ack_out;
        endcase
endmodule

// Code for Master 2 by 1 MUX to send ACK
module mast_ack(
    master_scl_sixt,
    master_ack_sel,
    master_ack_out
);
    input master_ack_sel;
    input master_scl_sixt;
    output reg master_ack_out;
    parameter ACK = 1'b0, NACK = 1'b1;

    always @(*)
        if (master_ack_sel)
            master_ack_out = ACK;
        else
            master_ack_out = NACK;
endmodule