`timescale 1ns/1ps

module TopLevel;
  reg S,R;
  wire Q,QN;
  latch_sr latch(S,R,Q,QN);

  initial begin
    S = 0; R = 0; #50
    $display("S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 0; R = 1; #50
    $display("S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 1; R = 0; #50
    $display("S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 1; R = 1; #50
    $display("S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    $finish;
  end
endmodule

module latch_sr(S,R,Q,QN);
  input S,R;
  output Q, QN; wire Q,QN;
  
  assign #1 Q = ~(R | QN);
  assign #1 QN = ~(S | Q);
endmodule
