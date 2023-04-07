`timescale 1ns/1ps

module TopLevel;
  reg clock, reset_;
  wire[3:0] Q;
  always #10 clock <= (!clock);

  initial begin
    $display ("time, \t clock, \t reset_, \t QQQQ");
    $monitor ("%g, \t %b, \t %b, \t %b", $time, clock, reset_, Q);
    reset_ = 1'b1;
    clock = 0;
    #5 reset_ = 1'b0;
    #20 reset_ = 1'b1;
    #600 $finish;
  end

  reg T; initial begin T = 1; #650 T = 0; end
  LAC_Carry_Counter lcc(Q, T, clock, reset_);

  //debug:
  wire q0=lcc.Q[0], q1=lcc.Q[1], q2=lcc.Q[2], q3=lcc.Q[3];
  wire[3:0] q= {lcc.Q[3],lcc.Q[2],lcc.Q[1],lcc.Q[0]};
  wire cout = lcc.cout;
endmodule

// LAC adder
module lac_full_adder(a, b, c, g, p, s);
  input a, b, c;
  output g, p, s;
  assign g = a & b;
  assign p = a ^ b;
  assign s = a ^ (b ^ c);
endmodule


// LAC Adder 4-bit
module lac_adder_4bit(a, b, cin, s, cout);
  input [3:0] a, b;
  input cin;
  output cout;
  output [3:0] s;
  wire [4:0] c;
  wire [3:0] g, p;

  assign c[0] = cin;
  assign cout = c[4];

  lac_full_adder add0(a[0], b[0], c[0], g[0], p[0], s[0]);
  assign c[1] = g[0] | (p[0] & c[0]);

  lac_full_adder add1(a[1], b[1], c[1], g[1], p[1], s[1]);
  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);

  lac_full_adder add2(a[2], b[2], c[2], g[2], p[2], s[2]);
  assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) |
  (p[2] & p[1] & p[0] & c[0]);
  
  lac_full_adder add3(a[3], b[3], c[3], g[3], p[3], s[3]);
  assign c[4] = g[3] | (p[3]&g[2]) | (p[3]& p[2]&g[1]) |
  (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&c[0]);
endmodule

module LAC_Carry_Counter(Q, T, clock, reset_);
  input clock, reset_, T;
  output[3:0] Q;
  reg[3:0] A, S;
  reg cin;
  wire[3:0] S1;
  wire cout;
  assign Q = S;

  always @(reset_==1)
    begin if (T==0) A <= 4'b0000; else A <= 4'b0001; end

  always @(reset_==0) #1 begin S <= 4'b0000; cin <= 1'b0; end

  lac_adder_4bit lacadd(A, S, cin, S1, cout);
  
  always @(negedge clock) if (reset_==1)
    #3 begin S<=S1; end
endmodule
