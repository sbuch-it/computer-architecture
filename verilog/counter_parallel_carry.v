`timescale 1ns/1ps
module TopLevel;
    reg clock; reg reset_;
    wire[3:0] Q;
    always #10 clock<=(!clock);
    initial begin
        $display ("time, \t clock, \t reset_, \t QQQQ");
        $monitor ("%g, \t %b, \t %b, \t %b", $time, clock, reset_, Q);
        reset_ = 1'b1;
        clock = 0;
        #5 reset_ = 1'b0;
        #20 reset_ = 1'b1;
        #600 $finish;
    end
    reg T; initial begin T=1; #650 T=0; end
    parallel_carry_counter prc(Q,T,clock,reset_);
    
    //debug:
    wire q0=prc.q0, q1=prc.q1, q2=prc.q2, q3=prc.q3;
    wire[3:0] q= {prc.q3,prc.q2,prc.q1,prc.q0};
    wire cout=prc.to3;
endmodule

// Flip-Flop T sensibile al fronte in discesa
// con riporto parallelo a 4-bit
module FFTnr(q,tin,c0,c1,c2,c3,tout,clock,reset_);
    input clock, reset_;
    input tin, c0, c1, c2, c3; 
    output q,tout;
    reg STAR;
    parameter S0=0,S1=1;
    assign q=(STAR==S0)?0:1;
    assign #1 tout = c0 & c1 & c2 & c3 & q;
    always @(reset_==0) #1 STAR <= S0;
    always @(negedge clock) if (reset_==1) #3
        casex(STAR)
            S0: STAR <= (tin==0)?S0:S1;
            S1: STAR <= (tin==1)?S0:S1;
        endcase
endmodule

module parallel_carry_counter(Q,T,clock,reset_);
    input clock, reset_,T;
    wire q0,q1,q2,q3,to0,to1,to2,to3;
    reg[3:0] Q1;
    output[3:0] Q; assign Q=Q1;
    
    FFTnr pc0(q0, T, T,1'b1,1'b1,1'b1, to0,clock,reset_);
    FFTnr pc1(q1,to0, T, q0,1'b1,1'b1, to1,clock,reset_);
    FFTnr pc2(q2,to1, T, q0, q1,1'b1, to2,clock,reset_);
    FFTnr pc3(q3,to2, T, q0, q1, q2, to3,clock,reset_);

    //notare che per non avere stati spuri in uscita conviene bufferizzare in un registro
    always @(negedge clock)
        begin Q1[0]<=q0; Q1[1]<=q1; Q1[2]<=q2; Q1[3]<=q3; end
endmodule

