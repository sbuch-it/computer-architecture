`timescale 1ns/1ps
module testbench;
    reg clock, _reset;
    wire[3:0] Q;
    ring_counter rc(Q,clock,_reset);
    always #10 clock = ~clock;
    initial begin
        $display("time,\t clock,\t _reset,\t QQQQ");
        $monitor("%g,\t %b,\t %b,\t %b", $time,clock,_reset,Q);
        _reset=1'b1;
        clock=0;
        #5 _reset=1'b0;
        #20 _reset=1'b1;
        #600 $finish;
    end
endmodule

module ring_counter(q,clock,_reset);
    input clock,_reset;
    output[3:0] q;
    reg[3:0] q;
    always @(posedge clock)
        if(!_reset)
            q<=4'b1000;
        else begin
            q[3]<=q[0];
            q[2]<=q[3];
            q[1]<=q[2];
            q[0]<=q[1];
        end
endmodule

